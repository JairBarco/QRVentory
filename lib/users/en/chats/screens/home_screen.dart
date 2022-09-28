import 'package:flutter/material.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'chats_screen.dart';
import 'friends_screen.dart';


class ChatsHomeScreen extends StatefulWidget {
  @override
  _ChatsHomeScreenState createState() => _ChatsHomeScreenState();
}

class _ChatsHomeScreenState extends State<ChatsHomeScreen> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization().messaging),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          ChatsScreen(),
          FriendsScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.chat_rounded),
              label: AppLocalization.of(context)!.messages
          ),

          BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt_rounded),
              label: AppLocalization().friends
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize:14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
      
    );
  }
}