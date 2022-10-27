import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/models/user_ride_request_information.dart';

import '../../../users/en/app_localization/app_localization.dart';
import '../../../users/en/assistants/assistant_methods.dart';
import '../../../users/en/widgets/progress_dialog.dart';
import '../assistants/black_theme_google_map.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  NewTripScreen({
    this.userRideRequestDetails
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController? newTripGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double topPaddingOfMap = 0.0;
  double bottomPaddingOfMap = 0.0;
  Position? driverCurrentPosition;
  String? buttonTitle = "Arrived";
  Color? buttonColor = Colors.green;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";

  bool isRequestDirectionDetails = false;

  Future<void> drawPolylineFromOriginToDestination(LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(message: AppLocalization.of(context)!.progressDialog,),
    );

    var directionDetailsInfo = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

    if (!mounted) return;
    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = pPoints.decodePolyline(
        directionDetailsInfo.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

      setOfPolyline.clear();

      setState(() {
        Polyline polyline = Polyline(
          color: Colors.indigo,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polyLinePositionCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
        );

        setOfPolyline.add(polyline);
      });

      LatLngBounds latLngBounds;

      if (originLatLng.latitude > destinationLatLng.latitude &&
          originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest: destinationLatLng,
            northeast: originLatLng
        );
      } else if (originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(
                originLatLng.latitude, destinationLatLng.longitude),
            northeast: LatLng(
                destinationLatLng.latitude, originLatLng.longitude)
        );
      } else if (originLatLng.latitude > destinationLatLng.latitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(
                destinationLatLng.latitude, originLatLng.longitude),
            northeast: LatLng(
                originLatLng.latitude, destinationLatLng.longitude)
        );
      } else {
        latLngBounds = LatLngBounds(
            southwest: originLatLng,
            northeast: destinationLatLng
        );
      }
      newTripGoogleMapController!.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, 65));

      Marker originMarker = Marker(
        markerId: const MarkerId("originID"),
        position: originLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      Marker destinationMarker = Marker(
        markerId: const MarkerId("destinationID"),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      setState(() {
        setOfMarkers.add(originMarker);
        setOfMarkers.add(destinationMarker);
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

  @override
  void initState() {
    super.initState();
    saveAssignedDriverDetailsToUserRideRequest();
  }

  createDriverIconMarker(){
    if(iconAnimatedMarker == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "img/car.png").then((value){
        iconAnimatedMarker = value;
      });
    }
  }

  getDriversLocationUpdatesAtRealTime(){
    // ignore: unused_local_variable
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedMarker!,
        infoWindow: InfoWindow(title: "Esta es tú ubicación")
      );

      setState(() {
        CameraPosition cameraPosition = CameraPosition(target: latLngLiveDriverPosition, zoom: 16);
        newTripGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere((element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();

      //Update driver location at realtime in database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": driverCurrentPosition!.longitude.toString()
      };

      FirebaseDatabase.instance.ref().child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation").set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async{
    if(isRequestDirectionDetails == false){
      isRequestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null){
        return;
      }

      var originLatLng = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);
      var destinationLatLng;

      if(rideRequestStatus == "accepted"){
        destinationLatLng = widget.userRideRequestDetails!.originLatLng;
      } else{
        destinationLatLng = widget.userRideRequestDetails!.destinationLatLng;
      }

      var directionInformation = await AssistantMethods.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLatLng);

      if(directionInformation != null){
        setState((){
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          //Google map
          GoogleMap(
            padding: EdgeInsets.only(top: topPaddingOfMap, bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            polylines: setOfPolyline,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newTripGoogleMapController = controller;
              //Black theme google map
              blackThemeGoogleMap(newTripGoogleMapController);
              var driverCurrentLatLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
              var userPickUpLatLng = widget.userRideRequestDetails!.originLatLng;
              setState(() {
                topPaddingOfMap = 60;
              });
              drawPolylineFromOriginToDestination(driverCurrentLatLng, userPickUpLatLng!);
              getDriversLocationUpdatesAtRealTime();
            },
          ),

          //UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: 0.5,
                    offset: Offset(0.6,0.6),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    //Duration
                    Text(durationFromOriginToDestination, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.lightGreenAccent),),

                    const SizedBox(height: 18,),

                    Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey
                    ),

                    const SizedBox(height: 8,),

                    //Username - icon
                    Row(
                      children: [
                        Text(widget.userRideRequestDetails!.userName!, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.lightGreenAccent),),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.phone_android, color: Colors.grey,),
                        )
                      ],
                    ),

                    const SizedBox(height: 18,),

                    //User pickup location
                    Row(
                      children: [
                        const SizedBox(height: 14,),
                        Image.asset(
                          "img/origin.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestDetails!.originAddress!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 18,),

                    //User dropOff location
                    Row(
                      children: [
                        Image.asset(
                          "img/destination.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestDetails!.destinationAddress!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24,),

                    Divider(
                        thickness: 2,
                        height: 2,
                        color: Colors.grey
                    ),

                    const SizedBox(height: 10,),

                    ElevatedButton.icon(
                        onPressed: (){

                        },
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor,
                      ),
                        icon: Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 25,
                        ),
                        label: Text(
                          buttonTitle!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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

  saveAssignedDriverDetailsToUserRideRequest(){
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref()
        .child("All Ride Requests").child(widget.userRideRequestDetails!.rideRequestId!);

    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    databaseReference.child("driverLocation").set(driverLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("driverId").set(onlineDriverData.id);
    databaseReference.child("driverName").set(onlineDriverData.name);
    databaseReference.child("driverPhone").set(onlineDriverData.phone);
    databaseReference.child("car_details").set(onlineDriverData.car_color.toString() + onlineDriverData.car_model.toString());

    saveRideRequestIdToDriverHistory();
  }

  saveRideRequestIdToDriverHistory(){
    DatabaseReference tripsHistoryRef =  FirebaseDatabase.instance.ref().child("drivers")
        .child(currentFirebaseDriver!.uid).child("history").child("tripsHistory");

    tripsHistoryRef.child(widget.userRideRequestDetails!.rideRequestId!).set(true);
  }
}