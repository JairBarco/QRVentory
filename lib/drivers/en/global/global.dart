import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app/drivers/en/models/driver_data.dart';
import 'package:users_app/drivers/en/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseDriver;
DriverModel? driverModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
String? driverVehicleType = "";
