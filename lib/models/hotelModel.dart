import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPlace {
  final String id;
  final Timestamp startTime;
  final Timestamp endTime;

  UsersPlace({
    required this.id,
    required this.startTime,
    required this.endTime,
  });
}