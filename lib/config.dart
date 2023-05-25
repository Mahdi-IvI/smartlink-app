import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartLink{
  static const String appName = 'SmartLink';

  static late FirebaseAuth auth;
  static late FirebaseFirestore fireStore;
  static late FirebaseApp firebaseApp;
  static late SharedPreferences sharedPreferences;
  static const themeStatus = "themeStatus";
  static const lastUsedRoomID = "lastUsedRoomID";


  static const String userUID = 'userUID';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';
  static String userCollection = "users";
  static String userImageUrl = "userImageUrl";




}