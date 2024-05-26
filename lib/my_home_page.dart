import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smartlink/components/loading.dart';
import 'package:smartlink/models/user_access_model.dart';
import 'package:smartlink/pages/chat_page.dart';
import 'package:smartlink/config/config.dart';
import 'package:smartlink/pages/my_introduction_screen.dart';
import 'package:smartlink/pages/place_info_page.dart';
import 'package:smartlink/pages/ticket_page.dart';
import 'package:smartlink/pages/my_access_page.dart';
import 'package:smartlink/pages/news_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/grade_list_item.dart';
import 'components/my_text.dart';
import 'models/place_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = Config.auth.currentUser?.displayName ?? "User";
  String userEmail = Config.auth.currentUser?.email ?? "User Email";
  String userPhoto = Config.auth.currentUser?.photoURL ?? Config.logoAddress;

  PlaceModel? selectedPlace;

  List<UserAccessModel> availablePlaces = [];
  List<PlaceModel> availablePlacesInfo = [];
  List<PlaceModel> places = [];
  List<UserAccessModel> userAccess = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAvailablePlaces();
    });
    super.initState();
  }

  Future getAvailablePlaces() async {
    return Config.fireStore
        .collection(Config.userCollection)
        .doc(Config.auth.currentUser!.uid)
        .collection(Config.userAccessCollection)
        .where(Config.endDateTime, isGreaterThanOrEqualTo: DateTime.now())
        .get()
        .then((QuerySnapshot availablePlacesSnapshot) {
      setState(() {
        availablePlaces.clear();
        for (var doc in availablePlacesSnapshot.docs) {
          availablePlaces.add(UserAccessModel.fromDocument(doc));
        }
        availablePlaces = availablePlaces.where((place) {
          DateTime startDateTime = place.startDateTime.toDate();
          DateTime endDateTime = place.endDateTime.toDate();
          return startDateTime.isBefore(DateTime.now()) &&
              endDateTime.isAfter(DateTime.now());
        }).toList();
        if (availablePlaces.isEmpty) {
          getPlaces();
        } else {
          getAvailablePlacesInfo(
              placesId: availablePlaces.map((p) => p.id).toList());
        }
      });
    });
  }

  Future getPlaces() async {
    await Config.fireStore
        .collection(Config.placesCollection)
        .where(Config.showPublic, isEqualTo: true)
        .get()
        .then((QuerySnapshot placesSnapshot) {
      setState(() {
        places.clear();
        for (var doc in placesSnapshot.docs) {
          places.add(PlaceModel.fromDocument(doc));
        }
      });
    });
  }

  Future getAvailablePlacesInfo({required List<String> placesId}) async {
    await Config.fireStore
        .collection(Config.placesCollection)
        .where(FieldPath.documentId, whereIn: placesId)
        .get()
        .then((QuerySnapshot placesSnapshot) {
      setState(() {
        availablePlacesInfo.clear();
        for (var doc in placesSnapshot.docs) {
          availablePlacesInfo.add(PlaceModel.fromDocument(doc));
        }
        selectedPlace = availablePlacesInfo.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getAvailablePlaces();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(availablePlaces.isEmpty
              ? AppLocalizations.of(context)!.availablePlaces
              : selectedPlace != null
                  ? selectedPlace!.name
                  : Config.appName),
          actions: [
            IconButton(
                onPressed: () {
                  showMyCode();
                },
                icon: const Icon(Icons.password))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                children: availablePlacesInfo.map((place) {
                  return ListTile(
                    title: Text(place.name),
                    onTap: () {
                      setState(() {
                        selectedPlace = place;
                        Navigator.pop(context);
                      });
                    },
                  );
                }).toList(),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.signOut),
                onTap: () {
                  Config.auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const MyIntroductionScreen()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
        body: availablePlaces.isEmpty && places.isEmpty
            ? const Center(
                child: WhiteLoading(),
              )
            : availablePlaces.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlaceInfoPage(place: places[index])));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.purple)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  places[index].images.isEmpty
                                      ? Config.logoAddress
                                      : places[index].images.first,
                                  width: 120,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          places[index].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          places[index].description,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : selectedPlace != null
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: items(
                            selectedPlace!,
                          ),
                        ),
                      )
                    : const Center(
                        child: WhiteLoading(),
                      ),
      ),
    );
  }

  List<InkWell> items(PlaceModel place) {
    List<InkWell> myItems = [
      InkWell(
        child: GradeListItem(
          icon: Icons.lock,
          title: AppLocalizations.of(context)!.openDoors,
        ),
        onTap: () async {
          String useFingerprint = AppLocalizations.of(context)!.useFingerprint;
          LocalAuthentication localAuth = LocalAuthentication();
          if (await localAuth.canCheckBiometrics) {
            bool didAuth =
                await localAuth.authenticate(localizedReason: useFingerprint);
            if (didAuth) {
              goToMyAccessPage(place: place);
            } else {
              showErrorMessage();
            }
          } else {}
        },
      ),
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlaceInfoPage(place: place)));
        },
        child: GradeListItem(
          icon: Icons.contacts,
          title: AppLocalizations.of(context)!.contactUs,
        ),
      ),
    ];
    if (place.groupChatEnabled) {
      myItems.add(InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChatPage(place: place)));
        },
        child: GradeListItem(
          icon: Icons.chat,
          title: AppLocalizations.of(context)!.chatRoom,
        ),
      ));
    }
    if (place.ticketSystemEnabled) {
      myItems.add(
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TicketPage(
                      place: place,
                    )));
          },
          child: GradeListItem(
            icon: Icons.info,
            title: AppLocalizations.of(context)!.ticket,
          ),
        ),
      );
    }
    if (place.newsEnabled) {
      myItems.add(
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsPage(
                          place: place,
                        )));
          },
          child: GradeListItem(
            icon: Icons.article,
            title: AppLocalizations.of(context)!.news,
          ),
        ),
      );
    }

    return myItems;
  }

  void goToMyAccessPage({required PlaceModel place}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAccessPage(
                  place: place,
                )));
  }

  void showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseTryAgain)));
  }

  Future<void> showMyCode() {
    Random random = Random();
    int myCode = random.nextInt(999999) + 100000;
    saveCode(
        code: myCode,
        validTill: DateTime.now().add(const Duration(minutes: 1)));

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.myPersonalCode),
              content: H3Text(
                text: myCode.toString(),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(AppLocalizations.of(context)!.generateAgain),
                  onPressed: () {
                    setState(() {
                      myCode = random.nextInt(999999) + 100000;
                      saveCode(
                          code: myCode,
                          validTill:
                              DateTime.now().add(const Duration(minutes: 1)));
                    });
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future saveCode({required int code, required DateTime validTill}) async {
    await Config.fireStore
        .collection(Config.userCollection)
        .doc(Config.auth.currentUser!.uid)
        .update({
      Config.code: [code.toString(), validTill]
    });
  }
}
