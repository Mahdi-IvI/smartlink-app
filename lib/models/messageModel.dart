import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late String id;
  late String messageText;
  late String messageSender;
  late String messageGetter;
  late Timestamp messageDate;
  late bool messageRead;

  MessageModel(
      {required this.id,
        required this.messageText,
        required this.messageSender,
        required this.messageGetter,
        required this.messageDate,
        required this.messageRead});


}