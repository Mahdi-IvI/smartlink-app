import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/config.dart';

class PlaceModel {
  String id;
  String name;
  String address;
  String city;
  String country;
  String description;
  String descriptionDe;
  bool groupChatEnabled;
  bool newsEnabled;
  bool ticketSystemEnabled;
  List<dynamic> images;
  List<dynamic> phoneNumbers;
  String postCode;
  bool showPublic;
  int stars;
  String email;
  String instagram;
  String facebook;
  String website;

  PlaceModel({required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.description,
    required this.descriptionDe,
    required this.groupChatEnabled,
    required this.newsEnabled,
    required this.ticketSystemEnabled,
    required this.images,
    required this.phoneNumbers,
    required this.email,
    required this.instagram,
    required this.facebook,
    required this.website,
    required this.postCode,
    required this.showPublic,
    required this.stars});

  factory PlaceModel.fromDocument(DocumentSnapshot doc) {
    return PlaceModel(
        id: doc.id,
        name: doc.get(Config.name),
        address: doc.get(Config.address),
        city: doc.get(Config.city),
        country: doc.get(Config.country),
        description: doc.get(Config.description),
        descriptionDe: doc.get(Config.descriptionDe),
        groupChatEnabled: doc.get(Config.groupChatEnabled),
        newsEnabled: doc.get(Config.newsEnabled),
        ticketSystemEnabled: doc.get(Config.ticketSystemEnabled),
        images: doc.get(Config.images),
        phoneNumbers: doc.get(Config.phoneNumbers),
        instagram: doc.get(Config.instagram),
        facebook: doc.get(Config.facebook),
        email: doc.get(Config.email),
        website: doc.get(Config.website),
        postCode: doc.get(Config.postCode),
        showPublic: doc.get(Config.showPublic),
        stars: doc.get(Config.stars));
  }
  
}