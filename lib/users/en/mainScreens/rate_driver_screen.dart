import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/global/global.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white60,
        child: Container(
          margin: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 22.0,
              ),
              Text(
                AppLocalization().rateTrip,
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 22.0,
              ),
              Divider(
                height: 4.0,
                thickness: 4.0,
              ),
              SizedBox(
                height: 22.0,
              ),
              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.green,
                borderColor: Colors.black,
                size: 46,
                onRatingChanged: (valueOfStarsChosen) {
                  countRatingStars = valueOfStarsChosen;
                  if (countRatingStars == 1) {
                    setState(() {
                      titleStarsRating = "Muy Malo";
                    });
                  }

                  if (countRatingStars == 2) {
                    setState(() {
                      titleStarsRating = "Malo";
                    });
                  }

                  if (countRatingStars == 3) {
                    setState(() {
                      titleStarsRating = "Bueno";
                    });
                  }

                  if (countRatingStars == 4) {
                    setState(() {
                      titleStarsRating = "Muy Bueno";
                    });
                  }

                  if (countRatingStars == 5) {
                    setState(() {
                      titleStarsRating = "Excelente";
                    });
                  }
                },
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                titleStarsRating,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SizedBox(
                height: 18.0,
              ),
              ElevatedButton(
                onPressed: () {
                  DatabaseReference rateDriverRef = FirebaseDatabase.instance
                      .ref()
                      .child("drivers")
                      .child(widget.assignedDriverId!)
                      .child("ratings");

                  rateDriverRef.once().then((snap) {
                    if (snap.snapshot.value == null) {
                      rateDriverRef.set(countRatingStars.toString());
                      Restart.restartApp();
                    } else {
                      double pasteRatings =
                          double.parse(snap.snapshot.value.toString());
                      double newAverageRatings =
                          (pasteRatings + countRatingStars) / 2;
                      rateDriverRef.set(newAverageRatings.toString());
                      Restart.restartApp();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 75)),
                child: Text(
                  AppLocalization().send,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
