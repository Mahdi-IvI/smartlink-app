import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class HistoryModel{
  String id;
  Timestamp logDateTime;
  String loggerUid;
  bool setStatusTo;

  HistoryModel({required this.id,required this.logDateTime, required this.loggerUid, required this.setStatusTo});

  factory HistoryModel.fromDocument(DocumentSnapshot doc) {
    return HistoryModel(
      id: doc.id,
      logDateTime: doc.get(Config.logDateTime),
      loggerUid: doc.get(Config.loggerUid),
      setStatusTo: doc.get(Config.setStatusTo),
    );
  }

  Map<String, dynamic> toJson() => {
    Config.logDateTime: logDateTime,
    Config.loggerUid: loggerUid,
    Config.setStatusTo: setStatusTo};
}