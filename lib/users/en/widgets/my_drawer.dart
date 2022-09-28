import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/splashScreen/splash_screen.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/chats/screens/home_screen.dart';
import 'package:users_app/users/en/widgets/language.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
           Container(
            height: 165,
            color: Colors.grey,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 25,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        widget.name.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Text(
                        widget.email.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16,),

          //drawer body
          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.history,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.profile,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              fAuthUser.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c) => const DriversSplashScreen()));
            },
            child: ListTile(
              leading: const Icon(Icons.drive_eta, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.driver,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => LanguageScreen()));
            },
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.language,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c) => ChatsHomeScreen()));
            },
            child: ListTile(
              leading: const Icon(Icons.message_rounded, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.messaging,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              fAuthUser.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
            },
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white54,),
              title: Text(
                AppLocalization.of(context)!.logOut,
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
