import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smartlink/components/button.dart';
import 'package:smartlink/config/config.dart';
import 'package:smartlink/pages/sign_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyIntroductionScreen extends StatefulWidget {
  const MyIntroductionScreen({super.key});

  @override
  State<MyIntroductionScreen> createState() => _MyIntroductionScreenState();
}

class _MyIntroductionScreenState extends State<MyIntroductionScreen> {

  void _onIntroEnd(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignPage()));
  }

  Widget _buildImage({required String assetName, double? width}) {
    return Image.asset(
      Config.logoAssetAddress,
      width: width ?? 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle:
          const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: EdgeInsets.zero,
      bodyFlex: 5,
      imageFlex: 3
    );

    return IntroductionScreen(
      globalBackgroundColor: Theme.of(context).primaryColor,
      //globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 5000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage(assetName: 'Du_ProIcon.png'),
          ),
        ),
      ),
      globalFooter: SizedBox(
          width: double.infinity,
          height: 60,
          child: Button(
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple,
              text: AppLocalizations.of(context)!.introductionScreenButtonText,
              onPressed: () {
                _onIntroEnd(context);
              })),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.firstIntroductionScreenTitle,
          body:
          AppLocalizations.of(context)!.firstIntroductionScreenBody,
          image: _buildImage(assetName: 'User flow-pana.png', width: 100),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppLocalizations.of(context)!.secondIntroductionScreenTitle,
          body:
          AppLocalizations.of(context)!.secondIntroductionScreenBody,
          image: _buildImage(assetName: 'Prototyping process-bro.png', width: 100),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title:
          AppLocalizations.of(context)!.thirdIntroductionScreenTitle,
          body:
          AppLocalizations.of(context)!.thirdIntroductionScreenBody,
          image: _buildImage(assetName: 'Messaging-amico.png', width: 100),
          decoration: pageDecoration,
        ),
      ],
      showSkipButton: false,
      showBackButton: false,
      showDoneButton: false,
      showNextButton: false,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: Colors.purple,
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
