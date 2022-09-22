import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:users_app/users/en/chat/states.dart';

import 'chat_detail.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  void callChatDetailScreen(BuildContext context, String name, String id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendId: id, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (BuildContext context) => CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text("Chats"),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
                    chatState.messages.values.toList().map((data) {
                      return Observer(
                        builder: (_) => CupertinoListTile(
                          onTap: () => callChatDetailScreen(
                              context,
                              usersState.users[data['friendId']]['name'] != null
                                  ? usersState.users[data['friendId']]['name']
                                  : '',
                              data['id']),
                          title: Text(
                              usersState.users[data['friendId']]['name'] != null
                                  ? usersState.users[data['friendId']]['name']
                                  : ''),
                          subtitle: Text(
                              usersState.users[data['friendId']]['status'] != null
                                  ? usersState.users[data['friendId']]['status']
                                  : ''),
                        ),
                      );
                    }).toList()))
          ],
        ));
  }
}