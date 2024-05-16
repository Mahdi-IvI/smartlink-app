import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlink/config/config.dart';

class RoomModel {
  String id;
  String location;
  String name;
  bool status;
  bool public;

  RoomModel(
      {required this.id,
        required this.location,
        required this.name,
        required this.status,
        required this.public});

  factory RoomModel.fromDocument(DocumentSnapshot doc) {
    return RoomModel(
      id: doc.id,
      location: doc.get(Config.location),
      name: doc.get(Config.name),
      status: doc.get(Config.status),
      public: doc.get(Config.public),
    );
  }
}