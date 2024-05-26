import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smartlink/models/history_model.dart';

import '../config/config.dart';
import '../models/room_model.dart';

class AccessScreenGridListItem extends StatelessWidget {
  final String roomId;
  final String hotelId;

  const AccessScreenGridListItem({
    super.key,
    required this.roomId,
    required this.hotelId,
  });

  Stream<RoomModel> getRoomInfo() {
    if (kDebugMode) {
      print(hotelId);
      print(roomId);
    }
    return Config.fireStore
        .collection(Config.placesCollection)
        .doc(hotelId)
        .collection(Config.roomsCollection)
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      return RoomModel.fromDocument(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomModel>(
      stream: getRoomInfo(),
      builder: (context, roomInfo) {
        if (roomInfo.hasError) {
          return const SizedBox();
        }

        if (roomInfo.hasData) {
          return InkWell(
            onTap: () async {
              bool status = roomInfo.data!.status;
              String useFingerPrint = AppLocalizations.of(context)!
                  .useFingerprintToOpen(roomInfo.data!.name);
              LocalAuthentication localAuth = LocalAuthentication();
              if (await localAuth.canCheckBiometrics) {
                bool didAuth = await localAuth.authenticate(
                    localizedReason: useFingerPrint);
                if (didAuth) {
                  await Config.fireStore
                      .collection(Config.placesCollection)
                      .doc(hotelId)
                      .collection(Config.roomsCollection)
                      .doc(roomId)
                      .update({Config.status: !status});

                  HistoryModel historyModel = HistoryModel(
                      id: "id",
                      logDateTime: Timestamp.now(),
                      loggerUid: Config.auth.currentUser!.uid,
                      setStatusTo: !status);
                  await Config.fireStore
                      .collection(Config.placesCollection)
                      .doc(hotelId)
                      .collection(Config.roomsCollection)
                      .doc(roomId)
                      .collection(Config.historyCollection)
                      .doc()
                      .set(historyModel.toJson());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.pleaseTryAgain)));
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                /*  boxShadow: const [
                  BoxShadow(
                    color: Colors.purple,
                    blurRadius: 10.0,
                  ),
                ],*/
              ),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        roomInfo.data!.status
                            ? Icons.lock_open
                            : Icons.lock_outline,
                        size: 38,
                        color: Colors.white,
                      ),
                      ListTile(
                        title: Center(
                          child: Text(
                            roomInfo.data!.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
