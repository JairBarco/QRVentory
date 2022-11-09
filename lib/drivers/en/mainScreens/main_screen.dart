import 'package:flutter/material.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

import '../tabPages/earning_tab.dart';
import '../tabPages/home_tab.dart';
import '../tabPages/profile_tab.dart';
import '../tabPages/ratings_tab.dart';

class DriversMainScreen extends StatefulWidget {
  @override
  State<DriversMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<DriversMainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeTabPage(),
          EarningsTabPage(),
          RatingsTabPage(),
          ProfileTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalization.of(context)!.home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.credit_card),
              label: AppLocalization.of(context)!.earnings),
          BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: AppLocalization.of(context)!.ratings),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalization.of(context)!.account),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
