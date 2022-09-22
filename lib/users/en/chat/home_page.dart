import 'package:flutter/cupertino.dart';
import 'package:users_app/users/en/chat/people.dart';
import 'package:users_app/users/en/chat/states.dart';

import 'chats.dart';

void main() => runApp(const HomePageCupertino());

class HomePageCupertino extends StatelessWidget {
  const HomePageCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      useInheritedMediaQuery: true,
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var screens = [Chats(), People()];

  @override
  void initState() {
    chatState.refreshChatsForCurrentUser();
    usersState.initUsersListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              label: "Chats",
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            ),
            BottomNavigationBarItem(
              label: "People",
              icon: Icon(CupertinoIcons.person_alt_circle),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      ),
    );
  }
}
