import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/global/global.dart';
import 'package:users_app/users/en/mainScreens/video_call.dart';
import '../widgets/message_textfield.dart';
import '../widgets/single_message.dart';

class ChatScreen extends StatelessWidget {
  final String currentUser;
  final String friendId;
  final String friendName;

  ChatScreen({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(friendName, style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => VideoCall()));
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(fAuthUser.currentUser!.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return Center(
                        child: Text(AppLocalization().sayHi),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              fAuthUser.currentUser!.uid;
                          return SingleMessage(
                              message: snapshot.data.docs[index]['message'],
                              isMe: isMe);
                        });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          )),
          MessageTextField(fAuthUser.currentUser!.uid.toString(), friendId),
        ],
      ),
    );
  }
}
