import 'package:flutter/material.dart';

import '../../../users/en/app_localization/app_localization.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalization.of(context)!.ratings),
    );
  }
}
