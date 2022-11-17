import 'dart:async';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users_app/drivers/en/models/driver_data.dart';
import 'package:users_app/drivers/en/models/user_model.dart';

import '../../../users/en/app_localization/app_localization.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseDriver;
DriverModel? driverModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
DriverData onlineDriverData = DriverData();
String? driverVehicleType = "";
String titleStarsRating = "Good";
String statusText = AppLocalization().nowOffline;
String statusTextOnline = AppLocalization().nowOnline;
Color buttonColor = Colors.red;
