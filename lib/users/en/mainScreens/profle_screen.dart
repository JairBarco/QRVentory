import 'package:flutter/material.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/global/global.dart';
import 'package:users_app/users/en/widgets/info_design_ui.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userModelCurrentInfo!.name!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.white),
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
              textInfo: userModelCurrentInfo!.phone!,
              iconData: Icons.phone_iphone,
            ),
            InfoDesignUIWidget(
              textInfo: userModelCurrentInfo!.email!,
              iconData: Icons.email,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(primary: Colors.indigo),
              child: Text(
                AppLocalization().close,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
