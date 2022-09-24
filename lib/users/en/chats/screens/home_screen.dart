import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/users/en/chats/screens/search_screen.dart';
import 'package:users_app/users/en/global/global.dart';
import 'chat_screen.dart';


class ChatsHomeScreen extends StatefulWidget {
  @override
  _ChatsHomeScreenState createState() => _ChatsHomeScreenState();
}

class _ChatsHomeScreenState extends State<ChatsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(fAuthUser.currentUser!.uid).collection('messages').snapshots(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.docs.length < 1){
              return Center(
                child: Text("No Chats Available !"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                var friendId = snapshot.data.docs[index].id;
                var lastMsg = snapshot.data.docs[index]['last_msg'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                  builder: (context,AsyncSnapshot asyncSnapshot){
                    if(asyncSnapshot.hasData){
                      var friend = asyncSnapshot.data;
                      return ListTile(
                        title: Text(friend['name'], style: TextStyle(color: Colors.black, fontSize: 17),),
                        subtitle: Container(
                          child: Text("$lastMsg",style: TextStyle(color: Colors.grey, fontSize: 12),overflow: TextOverflow.ellipsis,),
                        ),
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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(fAuthUser.currentUser!.uid)));
        },
      ),
      
    );
  }
}