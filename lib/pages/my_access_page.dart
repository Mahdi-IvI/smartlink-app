import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartlink/components/loading.dart';
import 'package:smartlink/models/place_model.dart';
import 'package:smartlink/models/user_access_model.dart';
import '../components/access_screen_grid_list_item.dart';
import '../config/config.dart';

class MyAccessPage extends StatefulWidget {
  const MyAccessPage({super.key, required this.place});

  final PlaceModel place;

  @override
  State<MyAccessPage> createState() => _MyAccessPageState();
}

class _MyAccessPageState extends State<MyAccessPage> {
  Stream<List<UserAccessModel>> getAvailableRooms() {
    return Config.fireStore
        .collection(Config.userCollection)
        .doc(Config.auth.currentUser!.uid)
        .collection(Config.userAccessCollection)
        .doc(widget.place.id)
        .collection(Config.roomsCollection)
        .snapshots()
        .map((snapshot) {
      if (kDebugMode) {
        print(snapshot.docs.length);
      }
      return snapshot.docs.map((doc) {
        return UserAccessModel.fromDocument(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: StreamBuilder<List<UserAccessModel>>(
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
                return AccessScreenGridListItem(
                  roomId: roomsSnapshot.data![index].id,
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
