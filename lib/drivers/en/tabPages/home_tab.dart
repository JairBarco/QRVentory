import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/drivers/en/assistants/assistant_methods.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/infoHandler/app_info.dart';
import 'package:users_app/drivers/en/push_notifications/push_notification_system.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

import '../assistants/black_theme_google_map.dart';
import '../mainScreens/main_screen.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();
  bool isDriverActive = false;
  double topPaddingOfMap = 0.0;
  double bottomPaddingOfMap = 0.0;

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.4746);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    AssistantMethods.readDriverRatings(context);
  }

  readCurrentDriverInformation() {
    currentFirebaseDriver = fAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];

        onlineDriverData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];
        driverVehicleType = (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
    AssistantMethods.readDriverEarnings(context);
  }

  @override
  void initState() {
    super.initState();
    readCurrentDriverInformation();
    FirebaseMessaging.instance.subscribeToTopic("chats");
    Provider.of<AppInfo>(context, listen: false)
        .allTripsHistoryInformationList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding:
              EdgeInsets.only(top: topPaddingOfMap, bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            //Black theme google map
            blackThemeGoogleMap(newGoogleMapController);

            locateDriverPosition();

            setState(() {
              topPaddingOfMap = 60;
            });
          },
        ),

        // UI for online offline driver
        statusText != statusTextOnline
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.maxFinite,
                color: Colors.black87,
              )
            : Container(),

        //button for online offline driver
        Positioned(
          top: statusText != statusTextOnline
              ? MediaQuery.of(context).size.height * 0.45
              : 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("////////////////////////////");
                  print("////////////////////////////");
                  print(isDriverActive.toString());
                  print("////////////////////////////");
                  print("////////////////////////////");

                  if (isDriverActive != true) //offline
                  {
                    driverIsOnlineNow();
                    updateDriversLocationAtRealTime();

                    setState(() {
                      statusText = statusTextOnline;
                      isDriverActive = true;
                      buttonColor = Colors.green;
                    });

                    //display Toast
                    Fluttertoast.showToast(
                        msg: AppLocalization.of(context)!.nowOnlineMessage);
                  } else //online
                  {
                    driverIsOfflineNow();

                    setState(() {
                      statusText = AppLocalization().nowOffline;
                      statusText = statusText;
                      isDriverActive = false;
                      buttonColor = Colors.red;
                    });

                    //display Toast
                    Fluttertoast.showToast(
                        msg: AppLocalization.of(context)!.nowOfflineMessage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: statusText != statusTextOnline
                    ? Text(
                        statusText,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    : const Icon(
                        Icons.phonelink_ring,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(currentFirebaseDriver!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseDriver!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseDriver!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => DriversMainScreen()));
    });
  }
}
