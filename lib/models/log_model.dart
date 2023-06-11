import 'package:cloud_firestore/cloud_firestore.dart';

class LogModel{
  final String id;
  final String loggerUid;
  final Timestamp dateTime;

  LogModel({
    required this.id,
    required this.loggerUid,
    required this.dateTime,
  });

}