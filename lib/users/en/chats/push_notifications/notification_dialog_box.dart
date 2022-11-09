import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/models/user_ride_request_information.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[800],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),
            Image.asset(
              "img/car_logo.png",
              width: 160,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppLocalization.of(context)!.newRide,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 14,
                      ),
                      Image.asset(
                        "img/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "img/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();
                        //Cancel the ride request
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalization.of(context)!.cancel.toUpperCase(),
                        style: const TextStyle(fontSize: 14.0),
                      )),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();
                        //Accept the ride request
                        acceptRideRequest(context);
                      },
                      child: Text(
                        AppLocalization.of(context)!.accept.toUpperCase(),
                        style: const TextStyle(fontSize: 14.0),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    String getRideRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getRideRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "This ride request do not exists.");
      }

      if (getRideRequestId == widget.userRideRequestDetails!.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(currentFirebaseDriver!.uid)
            .child("newRideStatus")
            .set("accepted");
        //send driver to newRide Screen
      } else {
        Fluttertoast.showToast(msg: "This ride request don't exists");
      }
    });
  }
}
