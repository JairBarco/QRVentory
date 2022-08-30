import 'package:flutter/material.dart';
import '../../../drivers/en/global/global.dart';
import '../../../users/en/app_localization/app_localization.dart';
import '../splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(
            AppLocalization.of(context)!.logOut
        ),
        onPressed: (){
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const DriversSplashScreen()));
        },
      ),
    );
  }
}
