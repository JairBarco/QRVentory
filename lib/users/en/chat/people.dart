import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:users_app/users/en/chat/states.dart';
import '../global/global.dart';
import 'chat_detail.dart';

class People extends StatelessWidget {
  People({Key? key}) : super(key: key);
  var currentUser = fAuthUser.currentUser!.uid;

  void callChatDetailScreen(BuildContext context, String name, String id) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendId: id, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text("People"),
        ),
        SliverToBoxAdapter(
          key: UniqueKey(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoSearchTextField(
              onChanged: (value) => usersState.setSearchTerm(value),
              onSubmitted: (value) => usersState.setSearchTerm(value),
            ),
          ),
        ),
        Observer(
          builder: (_) => SliverList(
            delegate: SliverChildListDelegate(
              usersState.people
                  .map(
                    (dynamic data) => CupertinoListTile(
                  onTap: () => callChatDetailScreen(
                      context,
                      data['name'] != null ? data['name'] : '', data['id']),
                  title: Text(data['name'] != null ? data['name'] : ''),
                  subtitle:
                  Text(data['status'] != null ? data['status'] : ''),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}