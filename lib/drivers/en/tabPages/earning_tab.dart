import 'package:flutter/material.dart';
import 'package:users_app/drivers/en/infoHandler/app_info.dart';
import 'package:provider/provider.dart';
import 'package:users_app/drivers/en/widgets/history_design_ui.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

class EarningsTabPage extends StatefulWidget {
  const EarningsTabPage({Key? key}) : super(key: key);

  @override
  State<EarningsTabPage> createState() => _EarningsTabPageState();
}

class _EarningsTabPageState extends State<EarningsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalization().totalEarnings,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$" +
                        Provider.of<AppInfo>(context, listen: false)
                            .driverTotalEarnings,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(primary: Colors.indigo),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    "img/car_logo.png",
                    width: 100,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    AppLocalization().tripsCompleted,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        Provider.of<AppInfo>(context, listen: false)
                            .allTripsHistoryInformationList
                            .length
                            .toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, i) => Divider(
                  color: Colors.white,
                  thickness: 2,
                  height: 2,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    color: Colors.white54,
                    child: HistoryDesignUIWidget(
                      tripsHistoryModel:
                          Provider.of<AppInfo>(context, listen: false)
                              .allTripsHistoryInformationList[i],
                    ),
                  );
                },
                itemCount: Provider.of<AppInfo>(context, listen: false)
                    .allTripsHistoryInformationList
                    .length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
          ),
        ],
      ),
    );
  }
}
