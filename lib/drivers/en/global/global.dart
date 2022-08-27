import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app/drivers/en/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseDriver;
DriverModel? driverModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;