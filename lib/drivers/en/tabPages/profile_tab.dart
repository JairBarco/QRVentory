import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/splashScreen/splash_screen.dart';
import 'package:users_app/drivers/en/widgets/info_design_ui.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import '../../../drivers/en/widgets/language.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              onlineDriverData.name!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.white),
            ),

            Text(
              titleStarsRating + " " + AppLocalization().driver,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white70),
            ),

            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.indigo,
                height: 2,
                thickness: 2,
              ),
            ),
            InfoDesignUIWidget(
              textInfo: onlineDriverData.phone!,
              iconData: Icons.phone_iphone,
            ),
            InfoDesignUIWidget(
              textInfo: onlineDriverData.email!,
              iconData: Icons.email,
            ),
            InfoDesignUIWidget(
              textInfo: AppLocalization().carModel + ": " + onlineDriverData.car_model!,
              iconData: Icons.car_repair,
            ),
            InfoDesignUIWidget(
              textInfo: AppLocalization().carColor + ": " + onlineDriverData.car_color!,
              iconData: Icons.car_repair,
            ),
            InfoDesignUIWidget(
              textInfo: AppLocalization().carNumber + ": " + onlineDriverData.car_number!,
              iconData: Icons.car_repair,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => DriversLanguageScreen()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.indigo),
                  child: Text(
                    AppLocalization().language,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    fAuth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const DriversSplashScreen()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.indigo),
                  child: Text(
                    AppLocalization().logOut,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
