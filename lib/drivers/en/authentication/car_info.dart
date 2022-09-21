import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import '../../../drivers/en/global/global.dart';
import '../splashScreen/splash_screen.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["Uber-X", "Uber-Black", "Bike"];
  String? selectedCarType;

  saveCarInfo(){
    final driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseDriver!.uid).child("car_details").set(driverCarInfoMap);

    DocumentReference ref = FirebaseFirestore.instance.collection('drivers').doc(currentFirebaseDriver!.uid).collection('car_details').doc(currentFirebaseDriver!.uid);
    ref.set(driverCarInfoMap);

    Fluttertoast.showToast(msg: AppLocalization.of(context)!.carDetailsSaved);
    Navigator.push(context, MaterialPageRoute(builder: (c) => const DriversSplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 24,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("img/logo1.png"),
              ),

              const SizedBox(height: 10,),

               Text(AppLocalization.of(context)!.carDetails, style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),),

              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.carModel,
                  hintText: AppLocalization.of(context)!.carModel,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              TextField(
                controller: carNumberTextEditingController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.carNumber,
                  hintText: AppLocalization.of(context)!.carNumber,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              TextField(
                controller: carColorTextEditingController,
                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.carColor,
                  hintText: AppLocalization.of(context)!.carColor,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              DropdownButton(
                iconSize: 26,
                dropdownColor: Colors.black,
                hint: Text(
                  AppLocalization.of(context)!.carType,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                value: selectedCarType,
                onChanged: (newValue)
                {
                  setState(() {
                  selectedCarType = newValue.toString();
                   });
                },
                  items: carTypesList.map((car){
                    return DropdownMenuItem(
                      value: car,
                      child: Text(
                        car,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (){
                  if(carColorTextEditingController.text.isNotEmpty && carNumberTextEditingController.text.isNotEmpty
                      && carModelTextEditingController.text.isNotEmpty && selectedCarType != null){
                    saveCarInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text(
                  AppLocalization.of(context)!.saveNowButton,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
