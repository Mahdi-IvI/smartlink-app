import 'package:flutter/material.dart';
import 'package:smartlink/config/config.dart';
import 'my_introduction_screen.dart';
import '../components/loading.dart';
import '../my_home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (Config.auth.currentUser == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MyIntroductionScreen()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MyHomePage()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              Config.logoAddress,
              width: 100,
            ),
            const SizedBox(height: 30),
            const WhiteLoading()
          ],
        ),
      ),
    );
  }
}
