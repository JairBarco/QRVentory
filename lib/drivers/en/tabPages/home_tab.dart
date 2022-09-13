import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/push_notifications/push_notification_system.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';

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

  Position? driverCurrentPosition;
  var geoLocator = Geolocator();

  Color buttonColor = Colors.red;
  bool isDriverActive = false;

  double topPaddingOfMap = 0.0;
  double bottomPaddingOfMap = 0.0;

  String statusText = AppLocalization().nowOffline;
  String statusTextOnline = AppLocalization().nowOnline;

  blackThemeGoogleMap(){
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  locateDriverPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14.4746);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  readCurrentDriverInformation(){
    currentFirebaseDriver = fAuth.currentUser;
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  @override
  void initState(){
    super.initState();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: topPaddingOfMap, bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;
            //Black theme google map
            blackThemeGoogleMap();

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
                  onPressed: (){
                    if(isDriverActive != true) //offline
                        {
                      driverIsOnlineNow();
                      updateDriversLocationAtRealTime();

                      setState(() {
                        statusText = statusTextOnline;
                        isDriverActive = true;
                        buttonColor = Colors.green;
                      });

                      //display Toast
                      Fluttertoast.showToast(msg: AppLocalization.of(context)!.nowOnlineMessage);
                    }
                    else //online
                        {
                      driverIsOfflineNow();

                      setState(() {
                        statusText = statusText;
                        isDriverActive = false;
                        buttonColor = Colors.grey;
                      });

                      //display Toast
                      Fluttertoast.showToast(msg: AppLocalization.of(context)!.nowOfflineMessage);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  child: statusText != statusTextOnline
                      ? Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
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

  driverIsOnlineNow() async{
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(
        currentFirebaseDriver!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) { });
  }

  updateDriversLocationAtRealTime(){
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;

      if(isDriverActive == true)
      {
        Geofire.setLocation(
            currentFirebaseDriver!.uid,
            driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude
        );
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow(){
    Geofire.removeLocation(currentFirebaseDriver!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseDriver!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 10),(){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> DriversMainScreen()));
    });
  }
}
