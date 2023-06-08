import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableRoom {
  final String id;
  final String roomId;
  final Timestamp startTime;
  final Timestamp endTime;

  AvailableRoom({
    required this.id,
    required this.roomId,
    required this.startTime,
    required this.endTime,
  });
}