import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app/drivers/en/global/global.dart';
import '../../../drivers/en/mainScreens/main_screen.dart';
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

  LocationPermission? _locationPermission;

  checkIfPermissionLocationAllowed() async{
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  startTimer(){
    Timer(const Duration(seconds:3),() async {
      if(fAuthUser.currentUser !=null){
        fAuthUser.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;

        currentFirebaseUser = fAuthUser.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
        //Navigator.push(context, MaterialPageRoute(builder: (c)=> DriversMainScreen()));
      } else {
        //send user to main screen
        Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //fAuth.signOut();
    //fAuthUser.signOut();
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
              Image.asset("img/logo.png"),
              const SizedBox(height: 10,),
              const Text(
                "Ship Driver",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
