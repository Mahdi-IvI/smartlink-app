import 'package:cloud_firestore/cloud_firestore.dart';

import '../config.dart';

class MessageModel {
  late String id;
  late String messageText;
  late String messageSender;
  late Timestamp messageDate;
  late bool messageRead;

  MessageModel(
      {required this.id,
        required this.messageText,
        required this.messageSender,
        required this.messageDate,
        required this.messageRead});
  MessageModel.fromJson(Map<String, dynamic> json, documentId) {
    id = documentId;
    messageText = json[SmartLink.messageText];
    messageSender = json[SmartLink.messageSender];
    messageDate = json[SmartLink.messageDate];
    messageRead = json[SmartLink.messageRead];
  }


}