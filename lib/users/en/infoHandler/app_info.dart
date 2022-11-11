import 'package:flutter/widgets.dart';
import 'package:users_app/users/en/models/trips_history_model.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripsList = [];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];

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

  updateAllTripsKeys(List<String> tripsLeyList){
    historyTripsList = tripsLeyList;
  }

  updateOverallTripsHistoryInformation(TripsHistoryModel eachTripHistory){
    allTripsHistoryInformationList.add(eachTripHistory);
  }
}
