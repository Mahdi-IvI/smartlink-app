
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartlink/Loading.dart';

import 'MyHomePage.dart';
import 'config.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logo.png",height: 150,),
          const SizedBox(height: kToolbarHeight,),
          const Text("Sign in and enjoy your smart apartment",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          const SizedBox(height: kToolbarHeight/2,),
          InkWell(
            onTap: (){
              signInWithGoogle();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              height: kToolbarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple, width: 2)
              ),
              child: _loading
                  ? const WhiteLoading()
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign in with google!")
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            height: kToolbarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.purple, width: 2)
            ),
            child: _loading
                ? const WhiteLoading()
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign in with phone!")
              ],
            ),
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
    await SmartLink.auth.signInWithCredential(credential).then((value) async {
      User? user = SmartLink.auth.currentUser;
      if (user != null) {
        await SmartLink.fireStore
            .collection(SmartLink.userCollection)
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            await SmartLink.fireStore
                .collection(SmartLink.userCollection)
                .doc(user.uid)
                .update({
              SmartLink.userUID: user.uid,
              SmartLink.userEmail: user.email,
              SmartLink.userName: user.displayName,
              SmartLink.userImageUrl: user.photoURL
            }).whenComplete(() {

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                      (route) => false);

            });
          } else {
            await SmartLink.fireStore
                .collection(SmartLink.userCollection)
                .doc(user.uid)
                .set({
              SmartLink.userUID: user.uid,
              SmartLink.userEmail: user.email,
              SmartLink.userName: user.displayName,
              SmartLink.userImageUrl: user.photoURL,
            }).then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const MyHomePage()),
                      (route) => false);
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Please try again',
              textDirection: TextDirection.rtl,
            )));
      }
    });
    setState(() {
      _loading = false;
    });
  }
}
