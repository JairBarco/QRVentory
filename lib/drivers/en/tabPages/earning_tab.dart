import 'package:flutter/material.dart';

import '../../../users/en/app_localization/app_localization.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  State<EarningsTabPage> createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalization.of(context)!.earnings),
    );
  }
}
