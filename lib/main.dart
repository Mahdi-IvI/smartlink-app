import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartlink/config.dart';

import 'MySplashPage.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SmartLink.auth = FirebaseAuth.instance;
  SmartLink.fireStore = FirebaseFirestore.instance;
  SmartLink.sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Link',
      theme: ThemeData(
        primaryColor: const Color(0xFF20063E),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF20063E), // Set your desired color
        ),
    ),
      home: const MySplashPage(),
    );
  }
}

