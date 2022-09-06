import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/users/en/global/global.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  const SelectNearestActiveDriversScreen({Key? key}) : super(key: key);

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: Text(
          "Nearest Online Drivers",
          style: const TextStyle(fontSize: 18,),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close,
          color: Colors.white,
          ),
          onPressed: (){
            //delete the ride request from database
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            color: Colors.grey,
            elevation: 3,
            shadowColor: Colors.green,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  "img/${(dList[index]["car_details"]["type"]).toString()}.png",
                  width: 70,
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dList[index]["name"],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54
                    ),
                ),
                  Text(
                    dList[index]["car_details"]["car_model"],
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54
                    ),
                  ),Text(
                    dList[index]["car_details"]["car_color"],
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54
                    ),
                  ),
                  SmoothStarRating(
                    rating: 3.5,
                    color: Colors.black,
                    borderColor: Colors.black,
                    allowHalfRating: true,
                    starCount: 5,
                    size: 15,
                  ),
              ],
            ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    "13 km",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
