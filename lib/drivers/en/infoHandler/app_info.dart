import 'package:flutter/widgets.dart';
import 'package:users_app/drivers/en/models/directions.dart';
import 'package:users_app/drivers/en/models/trips_history_model.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];
  String driverTotalEarnings = "0";

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropLocation) {
    userDropOffLocation = userDropLocation;
    notifyListeners();
  }

  updateOverallTripsCounter(int overallTripsCounter){
   countTotalTrips = overallTripsCounter;
  }

  updateAllTripsKeys(List<String> tripsKeyList){
    historyTripsList = tripsKeyList;
  }

  updateOverallTripsHistoryInformation(TripsHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
  }

  updateDriverTotalEarnings(String driverEarnings){
    driverTotalEarnings = driverEarnings;
  }
}