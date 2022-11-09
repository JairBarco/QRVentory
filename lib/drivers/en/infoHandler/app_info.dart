import 'package:flutter/widgets.dart';
import 'package:users_app/drivers/en/models/directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation, userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropLocation) {
    userDropOffLocation = userDropLocation;
    notifyListeners();
  }
}
