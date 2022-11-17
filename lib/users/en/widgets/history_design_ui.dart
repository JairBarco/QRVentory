import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

import '../models/trips_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {
  TripsHistoryModel? tripsHistoryModel;
  HistoryDesignUIWidget({this.tripsHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    String formattedDateTime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Driver name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    AppLocalization().driver + ": " + widget.tripsHistoryModel!.driverName!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "\$ " + widget.tripsHistoryModel!.fareAmount!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 2,
            ),

            //Car details
            Row(
              children: [
                Icon(
                  Icons.car_rental,
                  color: Colors.black,
                  size: 28,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripsHistoryModel!.car_details!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            //Pickup address
            Row(
              children: [
                Image.asset(
                  "img/origin.png",
                  height: 26,
                  width: 26,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.originAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 14,
            ),

            //DropOff address
            Row(
              children: [
                Image.asset(
                  "img/destination.png",
                  height: 26,
                  width: 26,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      widget.tripsHistoryModel!.destinationAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 14,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Text(
                  formatDateAndTime(widget.tripsHistoryModel!.time!),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
