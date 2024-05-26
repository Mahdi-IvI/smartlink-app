import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartlink/components/loading.dart';
import 'package:smartlink/components/my_outlined_button.dart';
import 'package:smartlink/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../my_home_page.dart';
import '../config/config.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signUp),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            Config.logoWithoutBgAddress,
            height: 150,
          ),
          const SizedBox(
            height: kToolbarHeight,
          ),
          Text(
            AppLocalizations.of(context)!.signPageMessage,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: kToolbarHeight / 2,
          ),
          MyOutlinedButton(
            text: AppLocalizations.of(context)!.signInWithGoogle,
            child: _loading ? const Loading() : null,
            onTap: () {
              if (!_loading) {
                signInWithGoogle();
              }
              setState(() {
                _loading = true;
              });
            },
          ),
        ],
      ),
    );
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await Config.auth.signInWithCredential(credential).then((value) async {
      User? user = Config.auth.currentUser;
      if (user != null) {
        await Config.fireStore
            .collection(Config.userCollection)
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot snapshot) async {
          UserModel userModel = UserModel(
              uid: user.uid,
              imageUrl: user.photoURL ?? "",
              email: user.email ?? "",
              username: user.displayName ?? "",
              code: ["code"]);

          if (snapshot.exists) {
            await Config.fireStore
                .collection(Config.userCollection)
                .doc(user.uid)
                .update(userModel.toJson())
                .whenComplete(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (route) => false);
            });
          } else {
            await Config.fireStore
                .collection(Config.userCollection)
                .doc(user.uid)
                .set(userModel.toJson())
                .then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                  (route) => false);
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          AppLocalizations.of(context)!.pleaseTryAgain,
          textDirection: TextDirection.rtl,
        )));
      }
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseTryAgain)));
    });
    setState(() {
      _loading = false;
    });
  }
}
