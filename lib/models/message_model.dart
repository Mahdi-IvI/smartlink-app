import 'package:cloud_firestore/cloud_firestore.dart';

import '../config.dart';

class MessageModel {
  late String id;
  late String text;
  late String sender;
  late Timestamp date;
  late bool read;

  MessageModel(
      {required this.id,
        required this.text,
        required this.sender,
        required this.date,
        required this.read});
  MessageModel.fromJson(Map<String, dynamic> json, documentId) {
    id = documentId;
    text = json[SmartLink.messageText];
    sender = json[SmartLink.messageSender];
    date = json[SmartLink.messageDate];
    read = json[SmartLink.messageRead];
  }


}