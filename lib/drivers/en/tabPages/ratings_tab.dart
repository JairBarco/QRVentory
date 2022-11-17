import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/infoHandler/app_info.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

class RatingsTabPage extends StatefulWidget {
  const RatingsTabPage({Key? key}) : super(key: key);

  @override
  State<RatingsTabPage> createState() => _RatingsTabPageState();
}

class _RatingsTabPageState extends State<RatingsTabPage> {
  double ratingsNumber = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatingsNumber();
  }

  getRatingsNumber(){
    ratingsNumber = double.parse(Provider.of<AppInfo>(context, listen: false).driverAverageRatings);
    setupRatingsTitle();
  }

  setupRatingsTitle(){
    if (ratingsNumber == 1) {
      setState(() {
        titleStarsRating = "Muy Malo";
      });
    }

    if (ratingsNumber == 2) {
      setState(() {
        titleStarsRating = "Malo";
      });
    }

    if (ratingsNumber == 3) {
      setState(() {
        titleStarsRating = "Bueno";
      });
    }

    if (ratingsNumber == 4) {
      setState(() {
        titleStarsRating = "Muy Bueno";
      });
    }

    if (ratingsNumber == 5) {
      setState(() {
        titleStarsRating = "Excelente";
      });
    }
  }

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
                AppLocalization().averageRating,
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
                rating: ratingsNumber,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.green,
                borderColor: Colors.black,
                size: 46,
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
            ],
          ),
        ),
      ),
    );
  }
}
