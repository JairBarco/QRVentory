import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/assistants/geofire_assistant.dart';
import 'package:users_app/users/en/mainScreens/rate_driver_screen.dart';
import 'package:users_app/users/en/mainScreens/search_places_screen.dart';
import 'package:users_app/users/en/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:users_app/users/en/models/active_nearby_available_drivers.dart';
import 'package:users_app/users/en/widgets/pay_fare_amount__dialog.dart';
import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../infoHandler/app_info.dart';
import '../widgets/my_drawer.dart';
import '../widgets/progress_dialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220.0;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  double topPaddingOfMap = 0.0;
  double bottomPaddingOfMap = 0.0;

  List<LatLng> pLineCoordinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  bool openNavigationDrawer = true;
  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearbyAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Conductor en camino";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus = "";
  bool requestPositionInfo = true;

  blackThemeGoogleMap() {
    createActiveNearbyDriverIcon();

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

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14.4746);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (!mounted) return;
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("Address = $humanReadableAddress");

    initializeGeoFireListener();

    AssistantMethods.readTripsKeyForOnlineUser(context);
  }

  @override
  void initState() {
    super.initState();
    generateAndGetToken();
    FirebaseMessaging.instance.subscribeToTopic("chats");
  }

  saveRideRequestInformation() {
    //Save the ride request
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();
    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key" : value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation.locationLongitude.toString()
    };

    Map destinationLocationMap = {
      //"key" : value,
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation.locationLongitude.toString()
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting"
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted
        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }

        //status = arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "El conductor ha llegado";
          });
        }

        //status = onTrip
        if (userRideRequestStatus == "ontrip") {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        //status = ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["fareAmount"].toString());
            var response = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext c) => PayFareAmountCollectionDialog(
                      fareAmount: fareAmount,
                    ));

            if (response == "cashPayed") {
              //Use can rate driver
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId =
                    (eventSnap.snapshot.value as Map)["driverId"].toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => RateDriverScreen(
                            assignedDriverId: assignedDriverId)));
                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });

    onlineNearbyAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      LatLng userPickUpPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              driverCurrentPositionLatLng, userPickUpPosition);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Conductor en camino: " +
            directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
      LatLng userDestinationPosition = LatLng(
          dropOffLocation!.locationLatitude!,
          dropOffLocation.locationLongitude!);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userDestinationPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "En camino al destino: " +
            directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  searchNearestOnlineDrivers() async {
    //No available drivers
    if (onlineNearbyAvailableDriversList.isEmpty) {
      //Cancel the ride request
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoordinatesList.clear();
      });

      Fluttertoast.showToast(msg: "No Online Drivers Available");

      Future.delayed(const Duration(milliseconds: 3000), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      });
      return;
    }

    //Drivers available
    await retrieveOnlineDriversInformation(onlineNearbyAvailableDriversList);

    if (!mounted) return;
    var response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => SelectNearestActiveDriversScreen(
                referenceRideRequest: referenceRideRequest)));

    if (response == "driverChosen") {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(chosenDriverId!)
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          //Send notification to the driver
          sendNotificationToDriverNow(chosenDriverId!);

          //Waiting response from driver
          showWaitingResponseFromDriverUI();

          //Driver's response
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(chosenDriverId!)
              .child("newRideStatus")
              .onValue
              .listen((eventSnapshot) {
            //Cancel the rideRequest
            if (eventSnapshot.snapshot.value == "idle") {
              Fluttertoast.showToast(
                  msg:
                      "El conductor ha cancelado el viaje. Selecciona otro conductor.");
              Restart.restartApp();
            }

            //Accept the rideRequest
            if (eventSnapshot.snapshot.value == "accepted") {
              showUIForAssignedDriverInfo();
            }
          });
        } else {
          Fluttertoast.showToast(msg: "This driver do not exist. Try again.");
        }
      });
    }
  }

  showUIForAssignedDriverInfo() {
    setState(() {
      searchLocationContainerHeight = 0.0;
      waitingResponseFromDriverContainerHeight = 0.0;
      assignedDriverInfoContainerHeight = 245.0;
    });
  }

  showWaitingResponseFromDriverUI() {
    setState(() {
      searchLocationContainerHeight = 0.0;
      waitingResponseFromDriverContainerHeight = 220.0;
    });
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //Assign ride requestId to new ride status in Drivers Parent node for the chosen driver
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //Automate the push notification
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //Send notification now
        AssistantMethods.sendNotificationToDriverNow(deviceRegistrationToken,
            referenceRideRequest!.key.toString(), context);
        Fluttertoast.showToast(msg: "Notificación Enviada Exitosamente");
      } else {
        Fluttertoast.showToast(msg: "Por favor selecciona otro conductor");
        return;
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await FirebaseMessaging.instance.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    FirebaseMessaging.instance.subscribeToTopic("allDrivers");
    FirebaseMessaging.instance.subscribeToTopic("allUsers");
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");

    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userModelCurrentInfo != null
                ? userModelCurrentInfo!.name
                : AppLocalization.of(context)!.yourName,
            email: userModelCurrentInfo != null
                ? userModelCurrentInfo!.email
                : AppLocalization.of(context)!.yourEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(
                top: topPaddingOfMap, bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              //Black theme Google Map
              blackThemeGoogleMap();

              setState(() {
                topPaddingOfMap = 60;
                bottomPaddingOfMap = 220;
              });

              locateUserPosition();
            },
          ),
          //Custom hamburger button
          Positioned(
            top: 70,
            left: 18,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //Refresh app automatically
                  Restart.restartApp();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.white,
                  size: 33,
                ),
              ),
            ),
          ),
          //UI search location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      //Origin Location
                      Row(
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalization.of(context)!.from,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 35)}..."
                                    : AppLocalization.of(context)!
                                        .notGettingAddressWarning,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      //Destination Location
                      GestureDetector(
                        onTap: () async {
                          var responseFromSearchScreen = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));

                          if (responseFromSearchScreen == "obtainedDropOff") {
                            setState(() {
                              openNavigationDrawer = false;
                            });
                            //Draw routes - draw polyline
                            await drawPolylineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalization.of(context)!.to,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context)
                                              .userDropOffLocation !=
                                          null
                                      ? "${Provider.of<AppInfo>(context).userDropOffLocation!.humanReadableAddress!.substring(0, 35)}..."
                                      : AppLocalization.of(context)!
                                          .dropOffLocation,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userDropOffLocation !=
                              null) {
                            saveRideRequestInformation();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select a destination");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: Text(
                            AppLocalization.of(context)!.requestRideButton),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //UI waiting response from driver
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Esperando confirmación del conductor...',
                        duration: Duration(seconds: 6),
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      ScaleAnimatedText(
                        'Espere por favor...',
                        duration: Duration(seconds: 10),
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                            fontSize: 35.0,
                            color: Colors.white,
                            fontFamily: 'Canterbury'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //UI for display driver information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Ride status
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //Driver name
                    Text(
                      driverName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    //Driver vehicle details
                    Text(
                      driverCarDetails,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //Call driver button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        icon: Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: Text(
                          "Llamar al conductor",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> drawPolylineFromOriginToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: AppLocalization.of(context)!.progressDialog,
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    if (!mounted) return;
    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoordinatesList.clear();

    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

      polyLineSet.clear();

      setState(() {
        Polyline polyline = Polyline(
          color: Colors.indigo,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinatesList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );

        polyLineSet.add(polyline);
      });

      LatLngBounds latLngBounds;

      if (originLatLng.latitude > destinationLatLng.latitude &&
          originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds =
            LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
      } else if (originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest:
                LatLng(originLatLng.latitude, destinationLatLng.longitude),
            northeast:
                LatLng(destinationLatLng.latitude, originLatLng.longitude));
      } else if (originLatLng.latitude > destinationLatLng.latitude) {
        latLngBounds = LatLngBounds(
            southwest:
                LatLng(destinationLatLng.latitude, originLatLng.longitude),
            northeast:
                LatLng(originLatLng.latitude, destinationLatLng.longitude));
      } else {
        latLngBounds =
            LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
      }
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));

      Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        infoWindow:
            InfoWindow(title: originPosition.locationName, snippet: "Origin"),
        position: originLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        infoWindow: InfoWindow(
            title: destinationPosition.locationName, snippet: "Destination"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );

      setState(() {
        markersSet.add(originMarker);
        markersSet.add(destinationMarker);
      });

      /*Circle originCircle = Circle(
        circleId: const CircleId("originID"),
        fillColor: Colors.white,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.black,
        center: originLatLng,
      );

      Circle destinationCircle = Circle(
        circleId: const CircleId("destinationID"),
        fillColor: Colors.white,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.black,
        center: destinationLatLng,
      );

      setState((){
        circlesSet.add(originCircle);
        circlesSet.add(destinationCircle);
      });*/
    }
  }

  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered: //Whenever any driver is online
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          case Geofire.onKeyExited: //Whenever any driver is offline
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onKeyMoved: //Whenever driver moves
            ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
                ActiveNearbyAvailableDrivers();
            activeNearbyAvailableDriver.locationLatitude = map['latitude'];
            activeNearbyAvailableDriver.locationLongitude = map['longitude'];
            activeNearbyAvailableDriver.driverId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onGeoQueryReady: //Display online drivers
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet = driversMarkerSet;
      });
    });
  }

  createActiveNearbyDriverIcon() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "img/car.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}
