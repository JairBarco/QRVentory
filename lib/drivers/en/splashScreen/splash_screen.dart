import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/mainScreens/main_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../../../drivers/en/global/global.dart';
import '../authentication/login_screen.dart';

class DriversSplashScreen extends StatefulWidget {
  const DriversSplashScreen({Key? key}) : super(key: key);

  @override
  State<DriversSplashScreen> createState() => _DriversSplashScreenState();
}

class _DriversSplashScreenState extends State<DriversSplashScreen> {
  LocationPermission? _locationPermission;

  checkIfPermissionLocationAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        currentFirebaseDriver = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => DriversMainScreen()));
      } else {
        //send user to main screen
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => DriversLoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIfPermissionLocationAllowed();
    super.initState();
    startTimer();
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
                Image.asset("img/logo1.png"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Ship Driver",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
      ),
    );
  }
}
