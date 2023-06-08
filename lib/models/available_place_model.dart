import 'package:cloud_firestore/cloud_firestore.dart';

class AvailablePlaceModel {
  final String id;
  final String placeId;
  final Timestamp startTime;
  final Timestamp endTime;

  AvailablePlaceModel({
    required this.id,
    required this.placeId,
    required this.startTime,
    required this.endTime,
  });
}