import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const String appName = 'Smartlink';

  static const String logoAddress =
      'https://firebasestorage.googleapis.com/v0/b/smartlink-pro.appspot.com/o/logo%2Fguest%20app%20logo.png?alt=media&token=8ba39061-d65c-43dd-9a22-61b074d4f9f2';

  static const String logoAssetAddress = "assets/logo.png";

  static late FirebaseAuth auth;
  static late FirebaseFirestore fireStore;
  static late FirebaseApp firebaseApp;
  static late SharedPreferences sharedPreferences;

  static String userCollection = "users";
  static const String imageUrl = "imageUrl";
  static const String username = "username";
  static String code = "code";
  static String phoneNumber = "phoneNumber";
  static String firstname = "firstname";
  static String lastname = "lastname";
  static String passportNumber = "passportNumber";

  static String placesCollection = "places";
  static String description = "description";
  static String descriptionDe = "descriptionDe";
  static String stars = "stars";
  static String images = "images";
  static String showPublic = "showPublic";
  static String address = "address";
  static String city = "city";
  static String postCode = "postCode";
  static String country = "country";
  static String groupChatEnabled = "groupChatEnabled";
  static String ticketSystemEnabled = "ticketSystemEnabled";
  static String newsEnabled = "newsEnabled";
  static String instagram = "instagram";
  static String facebook = "facebook";
  static String email = "email";
  static String website = "website";
  static String phoneNumbers = "phoneNumbers";

  static String userAccessCollection = "userAccess";
  static const String startDateTime = "startDateTime";
  static const String endDateTime = "endDateTime";

  static const String groupChatCollection = "groupChat";
  static const String text = "text";
  static const String dateTime = "dateTime";

  static const String ticketCollection = "tickets";
  static const String ticketMessageCollection = "ticketMessages";
  static const String subject = "subject";
  static const String lastMessageDateTime = "lastMessageDateTime";
  static const String lastSender = "lastSender";
  static const String senderUid = "senderUid";
  static const String createDateTime = "createDateTime";
  static const String read = "read";

  static const String historyCollection = "history";
  static const String loggerUid = "loggerUid";
  static const String setStatusTo = "setStatusTo";
  static const String logDateTime = "logDateTime";

  static const String roomsCollection = "rooms";
  static const String status = "status";
  static const String public = "public";
  static const String name = "name";
  static const String location = "location";

  static const String newsCollection = "news";
  static const String title = "title";
  static const String publishDateTime = "publishDateTime";
}
