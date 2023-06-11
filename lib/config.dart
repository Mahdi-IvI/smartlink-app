import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartLink{
  static const String appName = 'SmartLink';

  static const String logoAddress = 'https://picsum.photos/200/400';

  static const String errorMessage = 'Something went wrong!!!';

  static const String signOutText = 'Sign out';


  static const String availablePlacesText = 'Available Places';

  static late FirebaseAuth auth;
  static late FirebaseFirestore fireStore;
  static late FirebaseApp firebaseApp;
  static late SharedPreferences sharedPreferences;
  static const themeStatus = "themeStatus";
  static const lastUsedRoomID = "lastUsedRoomID";

  static String userCollection = "users";
  static const String userUID = 'UID';
  static const String userEmail = 'Email';
  static const String userName = 'userName';
  static String userImageUrl = "ImageUrl";


  static String placesCollection = "places";
  static String placeName = "name";
  static String placeDescription = "description";
  static String placePostcode = "postcode";
  static String placeStars = "stars";
  static String placeImages = "images";
  static String placeShowPublic = "showPublic";
  static String placeAddress = "address";



  static String userAccessCollection = "userAccess";
  static const String placeId = "placeId";


  static const String groupChatCollection = "groupChat";
  static const String messageText = "text";
  static const String messageSender = "sender";
  static const String messageDate = "date";
  static const String messageRead = "read";




  static const String historyCollection = "history";
  static const String loggerUid = "loggerUid";
  static const String logDateTime = "logDateTime";



  static const String roomsCollection = "rooms";
  static const String startTime = "startTime";
  static const String endTime = "endTime";
  static const String roomId = "roomId";
  static const String roomStatus = "status";
  static const String roomName = "name";
  static const String roomLocation = "location";


}