import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class UserModel {
  String uid;
  String imageUrl;
  String email;
  String username;
  String? phoneNumber;
  String? firstname;
  String? lastname;
  String? passportNumber;
  List<dynamic> code;

  UserModel(
      {required this.uid,
      required this.imageUrl,
      required this.email,
      required this.username,
      this.phoneNumber,
      this.firstname,
      this.lastname,
      this.passportNumber,
      required this.code});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        uid: doc.id,
        imageUrl: doc.get(Config.imageUrl),
        email: doc.get(Config.email),
        username: doc.get(Config.username),
        code: doc.get(Config.code),
        phoneNumber: doc.data().toString().contains(Config.phoneNumber) ? doc.get(Config.phoneNumber):null,
        firstname: doc.data().toString().contains(Config.firstname) ? doc.get(Config.firstname):null,
        lastname: doc.data().toString().contains(Config.lastname) ? doc.get(Config.lastname):null,
        passportNumber: doc.data().toString().contains(Config.passportNumber) ? doc.get(Config.passportNumber):null);
  }

  Map<String, dynamic> toJson() => {
    Config.email: email,
    Config.username: username,
    Config.imageUrl: imageUrl
  };

}
