import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class UserAccessModel {
  String id;
  Timestamp startDateTime;
  Timestamp endDateTime;

  UserAccessModel(
      {required this.id,
      required this.startDateTime,
      required this.endDateTime});

  factory UserAccessModel.fromDocument(DocumentSnapshot doc) {
    return UserAccessModel(
      id: doc.id,
      startDateTime: doc.get(Config.startDateTime),
      endDateTime: doc.get(Config.endDateTime),
    );
  }
}
