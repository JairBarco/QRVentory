import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app_localization/app_localization.dart';
import '../../global/global.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(fAuthUser.currentUser!.uid).collection('friends').snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length < 1){
                return Center(
                  child: Text(AppLocalization().noChatsAvailable),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    var friendId = snapshot.data.docs[index].id;
                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                      builder: (context,AsyncSnapshot asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            title: Text(friend['name'], style: TextStyle(color: Colors.black, fontSize: 20)),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
                                  currentUser: fAuthUser.currentUser!.uid,
                                  friendId: friend['id'],
                                  friendName: friend['name'])));
                            },
                          );
                        }
                        return LinearProgressIndicator();
                      },
                    );
                  });
            }
            return Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}
