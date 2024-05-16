import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartlink/config/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Config.auth = FirebaseAuth.instance;
  Config.fireStore = FirebaseFirestore.instance;
  Config.sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Link',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF20063E),
          appBarTheme:
              const AppBarTheme(color: Color(0xFF20063E), elevation: 0),
          scaffoldBackgroundColor: const Color(0xFF20063E),
          cardColor: const Color(0xFF20063E),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF20063E),
          )),
      home: const SplashScreen(),
    );
  }
}
