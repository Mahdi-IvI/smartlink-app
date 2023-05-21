
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smartlink/AvailablePlaces.dart';
import 'package:smartlink/config.dart';

import 'Loading.dart';
import 'MyHomePage.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();



  void _onIntroEnd(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AvailablePlaces()));
  }



  Widget _buildImage(String assetName, [double width = 200]) {
    return Image.asset(
      'assets/logo.png',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle:
      const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: const EdgeInsets.symmetric(vertical: 20),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: const EdgeInsets.only(top: 80),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 4000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('Du_ProIcon.png', 50),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Show Available Places',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Welcome to SmartLink!",
          body:
          "Experience the future of guest service management with our cutting-edge app. From opening your hotel room door to contacting the hotel management, SmartStay puts convenience at your fingertips. Enjoy a seamless and personalized stay with us.",
          image: _buildImage('User flow-pana.png',150),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Step into a new era of hospitality with SmartLink!",
          body: "Discover the power of our smart guest service management app that revolutionizes your hotel experience. Unlock your room door with a simple tap, and effortlessly connect with the hotel management for any assistance you need. Embrace a hassle-free stay with DoorLink.",
          image: _buildImage('Prototyping process-bro.png',150),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Discover the future of guest service with our innovative app!",
          body: "Say goodbye to traditional keycards and welcome a more intuitive way to access your room. Additionally, enjoy direct communication with our responsive hotel management team, ensuring your needs are met promptly. Experience hospitality reimagined.",
          image: _buildImage('Messaging-amico.png',150),
          decoration: pageDecoration,
        ),
      ],
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      showDoneButton: false,
      showNextButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}