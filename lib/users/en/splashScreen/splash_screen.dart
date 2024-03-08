import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';
import '../mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), _redirectUser);
  }

  Future<void> _redirectUser() async {
    await FirebaseAuth.instance.authStateChanges().first;

    if (fAuthUser.currentUser != null) {
      final snapshot = await ref.child('users/${fAuthUser.currentUser!.uid}/id').get();

      if (snapshot.exists != false) {
        await AssistantMethods.readCurrentOnlineUserInfo();
        currentFirebaseUser = fAuthUser.currentUser;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("img/logo.png"),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
