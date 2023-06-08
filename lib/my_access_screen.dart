import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smartlink/loading.dart';
import 'package:smartlink/models/place_model.dart';
import 'package:smartlink/models/room_model.dart';
import 'package:smartlink/models/available_room.dart';
import 'config.dart';
import 'models/available_place_model.dart';

class MyAccess extends StatefulWidget {
  const MyAccess({Key? key, required this.place, required this.placeName})
      : super(key: key);
  final PlaceModel place;
  final String placeName;

  @override
  State<MyAccess> createState() => _MyAccessState();
}

class _MyAccessState extends State<MyAccess> {
  Stream<List<AvailableRoom>> getAvailableRooms() {
    return SmartLink.fireStore
        .collection(SmartLink.userCollection)
        .doc(SmartLink.auth.currentUser!.uid)
        .collection(SmartLink.userAccessCollection)
        .doc(widget.place.id)
        .collection(SmartLink.roomsCollection)
        .where(SmartLink.endTime, isGreaterThanOrEqualTo: DateTime.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AvailableRoom(
          id: doc.id,
          roomId: doc[SmartLink.roomId],
          startTime: doc[SmartLink.startTime],
          endTime: doc[SmartLink.endTime],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: StreamBuilder<List<AvailableRoom>>(
          stream: getAvailableRooms(),
          builder: (BuildContext context, roomsSnapshot) {
            if (roomsSnapshot.hasError) {
              return Center(child: Text(roomsSnapshot.error.toString()));
            }

            if (roomsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: WhiteLoading());
            }
            if (kDebugMode) {
              print(roomsSnapshot.data!.length);
              print(widget.place.id);
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 30.0,
              ),
              itemCount: roomsSnapshot.data!.length,
              itemBuilder: (context, index) {
                return GradeListItem(
                  roomId: roomsSnapshot.data![index].roomId,
                  hotelId: widget.place.id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GradeListItem extends StatelessWidget {
  final String roomId;
  final String hotelId;

  const GradeListItem({
    Key? key,
    required this.roomId,
    required this.hotelId,
  }) : super(key: key);


  Stream<RoomModel> getRoomInfo() {
    return SmartLink.fireStore
        .collection(SmartLink.placesCollection)
        .doc(hotelId)
        .collection(SmartLink.roomsCollection)
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      return RoomModel(
          id: snapshot.id,
          status: snapshot[SmartLink.roomStatus],
          name: snapshot[SmartLink.roomName],
          location: snapshot[SmartLink.roomLocation]);
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
              LocalAuthentication localAuth = LocalAuthentication();
              if (await localAuth.canCheckBiometrics) {
                bool didAuth = await localAuth.authenticate(
                    localizedReason:
                        "Please use finger print to open ${roomInfo.data!.name}");
                if (didAuth) {
                  await SmartLink.fireStore
                      .collection(SmartLink.placesCollection)
                      .doc(hotelId)
                      .collection(SmartLink.roomsCollection)
                      .doc(roomId)
                      .update({SmartLink.roomStatus: true});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please try again")));
                }
              }
            },
            child: Container(
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
                      ),
                      ListTile(
                        title: Center(
                          child: Text(roomInfo.data!.name),
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
