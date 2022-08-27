import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/splashScreen/splash_screen.dart';

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
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.white54,),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.white54,),
              title: Text(
                "Profile",
                style: TextStyle(
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
            child: const ListTile(
              leading: Icon(Icons.drive_eta, color: Colors.white54,),
              title: Text(
                "Driver",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.language, color: Colors.white54,),
              title: Text(
                "Language",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){

            },
            child: const ListTile(
              leading: Icon(Icons.help_rounded, color: Colors.white54,),
              title: Text(
                "Help",
                style: TextStyle(
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
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.white54,),
              title: Text(
                "Log Out",
                style: TextStyle(
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
