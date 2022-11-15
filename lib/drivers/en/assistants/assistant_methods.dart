import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/drivers/en/assistants/request_assistant.dart';
import 'package:users_app/drivers/en/global/global.dart';
import 'package:users_app/drivers/en/global/map_key.dart';
import 'package:users_app/drivers/en/infoHandler/app_info.dart';
import 'package:users_app/drivers/en/models/direction_details_info.dart';
import 'package:users_app/drivers/en/models/directions.dart';
import 'package:users_app/drivers/en/models/trips_history_model.dart';
import 'package:users_app/drivers/en/models/user_model.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKeyAndroid";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseDriver = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseDriver!.uid);
    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        driverModelCurrentInfo = DriverModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKeyAndroid";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == ["Error Occurred, Failed. No Response."]) {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdate() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseDriver!.uid);
  }

  static startLiveLocationUpdate() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseDriver!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    double timeTraveledFareAmountPerMinute =
        (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer =
        (directionDetailsInfo.duration_value! / 1000) * 0.1;
    double totalFareAmount = (timeTraveledFareAmountPerMinute +
            distanceTraveledFareAmountPerKilometer) *
        20.00;

    if (driverVehicleType == "Bike") {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (driverVehicleType == "Uber-X") {
      return totalFareAmount.truncate().toDouble();
    } else if (driverVehicleType == "Uber-Black") {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return totalFareAmount.truncate().toDouble();
    }
  }

  static void readTripsKeysForOnlineDriver(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(fAuth.currentUser!.uid)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        Map keysTripsId = snap.snapshot.value as Map;

        //count total number trips and share it with Provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppInfo>(context, listen: false).updateOverallTripsCounter(overAllTripsCounter);

        //share trips keys with Provider
        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value)
        {
          tripsKeysList.add(key);
        });
        Provider.of<AppInfo>(context, listen: false).updateAllTripsKeys(tripsKeysList);

        //get trips keys data - read trips complete information
        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context)
  {
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsList;

    for(String eachKey in tripsAllKeys)
    {
      FirebaseDatabase.instance.ref()
          .child("All Ride Requests")
          .child(eachKey)
          .once()
          .then((snap)
      {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

        if((snap.snapshot.value as Map)["status"] == "ended")
        {
          //update-add each history to OverAllTrips History Data List
          Provider.of<AppInfo>(context, listen: false).updateOverallTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  //readDriverEarnings
  static void readDriverEarnings(context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(fAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
      {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppInfo>(context, listen: false).updateDriverTotalEarnings(driverEarnings);
      }
    });

    readTripsKeysForOnlineDriver(context);
  }
}
