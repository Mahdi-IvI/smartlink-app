import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smartlink/ChatPage.dart';
import 'package:smartlink/loading.dart';
import 'package:smartlink/config.dart';
import 'package:smartlink/models/available_place_model.dart';
import 'package:smartlink/my_access_screen.dart';

import 'my_introduction_screen.dart';
import 'models/place_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = SmartLink.auth.currentUser?.displayName ?? "User";
  String userEmail = SmartLink.auth.currentUser?.email ?? "User Email";
  String userPhoto =
      SmartLink.auth.currentUser?.photoURL ?? SmartLink.logoAddress;

  Stream<List<AvailablePlaceModel>> getAvailablePlaces() {
    return SmartLink.fireStore
        .collection(SmartLink.userCollection)
        .doc(SmartLink.auth.currentUser!.uid)
        .collection(SmartLink.userAccessCollection)
        .where(SmartLink.endTime, isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AvailablePlaceModel(
          id: doc.id,
          placeId: doc[SmartLink.placeId],
          startTime: doc[SmartLink.startTime],
          endTime: doc[SmartLink.endTime],
        );
      }).toList();
    });
  }

  Stream<List<PlaceModel>> getPlaces() {
    return SmartLink.fireStore
        .collection(SmartLink.placesCollection)
        .where(SmartLink.placeShowPublic, isEqualTo: true)
        .snapshots()
        .map((placesSnapshot) {
      return placesSnapshot.docs.map((place) {
        return PlaceModel(
          id: place.id,
          name: place[SmartLink.placeName],
          stars: place[SmartLink.placeStars],
          showPublic: place[SmartLink.placeShowPublic],
          address: place[SmartLink.placeAddress],
          description: place[SmartLink.placeDescription],
          images: place[SmartLink.placeImages],
          postcode: place[SmartLink.placePostcode],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AvailablePlaceModel>>(
      stream: getAvailablePlaces(),
      builder: (BuildContext context, availablePlacesSnapshot) {
        if (availablePlacesSnapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(SmartLink.appName),
              ),
              body: const Center(
                child: Text(SmartLink.errorMessage),
              ));
        }

        if (availablePlacesSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(SmartLink.appName),
              ),
              body: const Center(
                child: Loading(),
              ));
        }

        List<AvailablePlaceModel> userPlacesId =
            availablePlacesSnapshot.data!.where((hotel) {
          DateTime hotelStartTime = hotel.startTime
              .toDate();
          DateTime hotelEndTime = hotel.endTime
              .toDate();

          return hotelStartTime.isBefore(DateTime.now()) &&
              hotelEndTime.isAfter(DateTime.now());
        }).toList();
        List<String> placesId =
            userPlacesId.map((place) => place.placeId).toList();
        if (kDebugMode) {
          print(placesId);
          print(userPlacesId);
          print(SmartLink.auth.currentUser!.email);
        }
        Stream<List<PlaceModel>> getPlacesStream() {
          return SmartLink.fireStore
              .collection(SmartLink.placesCollection)
              .where(FieldPath.documentId, whereIn: placesId)
              .snapshots()
              .map((snapshot) {
            return snapshot.docs.map((doc) {
              return PlaceModel(
                  id: doc.id,
                  name: doc[SmartLink.placeName],
                  address: doc[SmartLink.placeAddress],
                  description: doc[SmartLink.placeDescription],
                  postcode: doc[SmartLink.placePostcode],
                  stars: doc[SmartLink.placeStars],
                  images: doc[SmartLink.placeImages],
                  showPublic: doc[SmartLink.placeShowPublic]);
            }).toList();
          });
        }

        return userPlacesId.isNotEmpty
            ? StreamBuilder<List<PlaceModel>>(
                stream: getPlacesStream(),
                builder: (BuildContext context, availablePlacesInfoSnapshot) {
                  if (availablePlacesInfoSnapshot.hasError) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text(SmartLink.appName),
                        ),
                        body: Center(
                          child: Text(
                              availablePlacesInfoSnapshot.error.toString()),
                        ));
                  }

                  if (availablePlacesInfoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text(SmartLink.appName),
                        ),
                        body: const Center(
                          child: Loading(),
                        ));
                  }
                  return Scaffold(
                      appBar: AppBar(
                        title: Text(userPlacesId.length == 1
                            ? availablePlacesInfoSnapshot.data!.first.name
                            : SmartLink.appName),
                      ),
                      drawer: Drawer(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountName: Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              accountEmail: Text(userEmail),
                              currentAccountPicture: CircleAvatar(
                                backgroundImage: NetworkImage(userPhoto),
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: availablePlacesInfoSnapshot.data!.map((place) {
                                return ListTile(
                                  title: Text(place.name),
                                );
                              }).toList(),
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text(SmartLink.signOutText),
                              onTap: () {
                                SmartLink.auth.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const MyIntroductionScreen()),
                                    (route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            InkWell(
                              child: const GradeListItem(
                                icon: Icons.lock,
                                title: 'Open Doors',
                              ),
                              onTap: () async {
                                LocalAuthentication localAuth =
                                LocalAuthentication();
                                if (await localAuth.canCheckBiometrics) {
                                  bool didAuth = await localAuth.authenticate(
                                      localizedReason:
                                      "Please use finger print to open doors");
                                  if (didAuth) {
                                    openRoom(availablePlacesInfoSnapshot
                                        .data!.first, availablePlacesInfoSnapshot
                                        .data!.first.name,availablePlacesSnapshot.data!.first.id
                                    );
                                  } else {
                                    showErrorMessage();
                                  }
                                }
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        placeId:
                                        availablePlacesInfoSnapshot.data!.first.id,
                                        placeName: availablePlacesInfoSnapshot
                                            .data!.first.name)));
                              },
                              child: const GradeListItem(
                                icon: Icons.chat,
                                title: 'Chat Room',
                              ),
                            ),
                            const GradeListItem(
                              icon: Icons.info,
                              title: 'Ticket',
                            ),
                            const GradeListItem(
                              icon: Icons.article,
                              title: 'News',
                            ),

                            const GradeListItem(
                              icon: Icons.contacts,
                              title: 'Contact us',
                            ),
                          ],
                        ),
                      ));
                },
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text(SmartLink.availablePlacesText),
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        accountEmail: Text(userEmail),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(userPhoto),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text(SmartLink.signOutText),
                        onTap: () {
                          SmartLink.auth.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const MyIntroductionScreen()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
                body:

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder<List<PlaceModel>>(
                    stream: getPlaces(),
                    builder: (BuildContext context, placesSnapshot) {
                      if (placesSnapshot.hasError) {
                        return Center(child: Text(placesSnapshot.error.toString()));
                      }

                      if (placesSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: WhiteLoading());
                      }

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 4/1.5,
                          crossAxisSpacing: 30.0,
                          mainAxisSpacing: 30.0,
                        ),
                        itemCount: placesSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.purple)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      placesSnapshot.data![index].images.first,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child:  Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              placesSnapshot.data![index].name,

                                              style:
                                              const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                                            ),
                                            Text(placesSnapshot.data![index].description, maxLines: 4,
                                              overflow: TextOverflow.ellipsis,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),




        );
      },
    );
  }

  void openRoom(PlaceModel model, String placeName, String availablePlaceId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAccess(
                place: model,
                placeName: placeName,
            accessId: availablePlaceId,)));
  }

  void showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please try again!")));
  }
}

class GradeListItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const GradeListItem({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.purple,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Card(
          shadowColor: Colors.purple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 38,
              ),
              ListTile(
                title: Center(
                  child: Text(title),
                ),
              ),
            ],
          )),
    );
  }
}
