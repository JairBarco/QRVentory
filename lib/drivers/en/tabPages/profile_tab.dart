import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/widgets/language.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import '../../../drivers/en/global/global.dart';
import '../splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        ElevatedButton(
          child: Text(
              AppLocalization.of(context)!.logOut
          ),
          onPressed: (){
            fAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const DriversSplashScreen()));
          },
        ),
        ElevatedButton(
          child: Text(
              AppLocalization.of(context)!.language
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> DriversLanguageScreen()));
          },
        ),
      ]
    );
  }
}
