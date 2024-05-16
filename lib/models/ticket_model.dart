import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class TicketModel {
  String id;
  String subject;
  Timestamp lastMessageDateTime;
  String senderUid;
  bool read;
  String lastSender;
  Timestamp createDateTime;
  String description;

  TicketModel(
      {required this.id,
        required this.subject,
        required this.lastMessageDateTime,
        required this.senderUid,
        required this.read,
        required this.lastSender,
        required this.createDateTime,
        required this.description});

  factory TicketModel.fromDocument(DocumentSnapshot doc) {
    return TicketModel(
        id: doc.id,
        subject: doc.get(Config.subject),
        lastMessageDateTime: doc.get(Config.lastMessageDateTime),
        senderUid: doc.get(Config.senderUid),
        read: doc.get(Config.read),
        lastSender: doc.get(Config.lastSender),
        createDateTime: doc.get(Config.createDateTime),
        description: doc.get(Config.description));
  }

  Map<String, dynamic> toJson() => {
    Config.subject: subject,
    Config.senderUid: senderUid,
    Config.description: description,
    Config.createDateTime: createDateTime,
  };
}