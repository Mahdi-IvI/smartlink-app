import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smartlink/Loading.dart';
import 'package:smartlink/config.dart';
import 'package:smartlink/models/hotelModel.dart';

import 'IntroductionPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = SmartLink.auth.currentUser?.displayName ?? "User";
  String userEmail = SmartLink.auth.currentUser?.email ?? "User Email";
  String userPhoto =
      SmartLink.auth.currentUser?.photoURL ?? "https://picsum.photos/200/400";

  Stream<List<UsersPlace>> getHotelStreamFromFirestore() {
    return SmartLink.fireStore
        .collection("users")
        .doc(SmartLink.auth.currentUser!.uid)
        .collection("access")
        .where("endTime", isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Convert each document snapshot into a Hotel object
        return UsersPlace(
          id: doc['hotelId'],
          startTime: doc['startTime'],
          endTime: doc['endTime'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsersPlace>>(
      stream: getHotelStreamFromFirestore(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }

        List<UsersPlace> usersPlaceId = snapshot.data!;
        List<String> placesId = usersPlaceId.map((hotel) => hotel.id).toList();
        if (kDebugMode) {
          print(placesId);
          print(usersPlaceId);
          print(SmartLink.auth.currentUser!.email);
        }

        return
        Scaffold(
            appBar: AppBar(
              title: Text(snapshot.hasData ? "SmartLink" : "Available Places"),
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
                  usersPlaceId.isNotEmpty?
                  StreamBuilder<QuerySnapshot>(
                    stream: SmartLink.fireStore.collection("hotels")
                        .where(FieldPath.documentId, whereIn: placesId)
                        .snapshots(),

                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> hotelsSnapshot) {
                      if (hotelsSnapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (hotelsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      return ListView(
                        shrinkWrap: true,
                        children: hotelsSnapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return ListTile(
                            title: Text(data['name']),
                          );
                        }).toList(),
                      );
                    },
                  ):const SizedBox(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign out'),
                    onTap: () {
                      SmartLink.auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const IntroductionPage()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
            body: usersPlaceId.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        const GradeListItem(
                          icon: Icons.chat,
                          title: 'Group Chat',
                          subtitle: 'Join the conversation',
                        ),
                        const GradeListItem(
                          icon: Icons.info,
                          title: 'Ticket',
                          subtitle: 'Get your event ticket',
                        ),
                        const GradeListItem(
                          icon: Icons.article,
                          title: 'News',
                          subtitle: 'Stay up-to-date',
                        ),
                        InkWell(
                          child: const GradeListItem(
                            icon: Icons.lock,
                            title: 'Door Opener',
                            subtitle: 'Unlock the door',
                          ),
                          onTap: () async {
                            LocalAuthentication localAuth =
                                LocalAuthentication();
                            if (await localAuth.canCheckBiometrics) {
                              bool didAuth = await localAuth.authenticate(
                                  localizedReason:
                                      "Please use finger print to open the door");
                              if (didAuth) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("worked")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("did not work")));
                              }
                            }
                          },
                        ),
                        const GradeListItem(
                          icon: Icons.contacts,
                          title: 'Contacts',
                          subtitle: 'Find your contacts',
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hotel 1",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Description"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hotel 1",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Description"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hotel 1",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Description"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https://cf.bstatic.com/xdata/images/hotel/max1024x768/370564672.jpg?k=4f37af06c05a6f5dfc7db5e8e71d2eb66cae6eec36af7a4a4cd7a25d65ceb941&o=&hp=1",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hotel 1",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("Description"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ));

      },
    );
  }
}

class GradeListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const GradeListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
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
