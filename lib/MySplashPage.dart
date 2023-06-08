import 'package:flutter/material.dart';
import 'package:smartlink/config.dart';
import 'my_introduction_screen.dart';
import 'loading.dart';
import 'MyHomePage.dart';

class MySplashPage extends StatefulWidget {
  const MySplashPage({Key? key}) : super(key: key);

  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (SmartLink.auth.currentUser == null) {
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
              SmartLink.logoAddress,
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
