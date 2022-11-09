import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../generated/intl/messages_all.dart';

class AppLocalization {
  static Future<AppLocalization> load(Locale locale) {
    final String name =
        locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  //Users App
  //Main Screen
  String get from {
    return Intl.message('From', name: 'From');
  }

  String get to {
    return Intl.message('To', name: 'To');
  }

  String get originLocation {
    return Intl.message('Origin Location', name: 'originLocation');
  }

  String get notGettingAddressWarning {
    return Intl.message('Not Getting Address',
        name: 'notGettingAddressWarning');
  }

  String get dropOffLocation {
    return Intl.message('Search DropOff Locations', name: 'dropOffLocation');
  }

  String get requestRideButton {
    return Intl.message('Request a Ride', name: 'requestRideButton');
  }

  //Drawer
  String get yourName {
    return Intl.message('Your Name', name: 'yourName');
  }

  String get yourEmail {
    return Intl.message('Your e-mail', name: 'yourEmail');
  }

  String get history {
    return Intl.message('History', name: 'history');
  }

  String get profile {
    return Intl.message('Profile', name: 'profile');
  }

  String get driver {
    return Intl.message('Driver', name: 'driver');
  }

  String get language {
    return Intl.message('Language', name: 'language');
  }

  String get help {
    return Intl.message('Help', name: 'help');
  }

  String get logOut {
    return Intl.message('Log Out', name: 'logOut');
  }

  String get messages {
    return Intl.message('Messages', name: 'messages');
  }

  //Search Places Screen
  String get searchHeader {
    return Intl.message('Search & Set Drop off Location', name: 'searchHeader');
  }

  String get search {
    return Intl.message('Search Here...', name: 'search');
  }

  //Progress Dialog
  String get progressDialog {
    return Intl.message('Please Wait...', name: 'progressDialog');
  }

  //LoginScreen
  //Validations
  String get emailMandatory {
    return Intl.message('Email is Mandatory', name: 'emailMandatory');
  }

  String get emailNotValid {
    return Intl.message('Email is not valid', name: 'emailNotValid');
  }

  String get passwordIsRequired {
    return Intl.message('Password is required', name: 'passwordIsRequired');
  }

  String get loginSuccessful {
    return Intl.message('Login Successful', name: 'loginSuccessful');
  }

  String get emailNotVerified {
    return Intl.message('Email not verified', name: 'emailNotVerified');
  }

  String get noRecordExistsWithThisEmail {
    return Intl.message('No record exists with this email',
        name: 'noRecordExistsWithThisEmail');
  }

  String get errorDuringLogin {
    return Intl.message('Error occurred during Login',
        name: 'errorDuringLogin');
  }

  //Fields
  String get login {
    return Intl.message('Login', name: 'login');
  }

  String get email {
    return Intl.message('Email', name: 'email');
  }

  String get password {
    return Intl.message('Password', name: 'password');
  }

  String get loginButton {
    return Intl.message('Login', name: 'loginButton');
  }

  String get register {
    return Intl.message("Don't have an account? SignUp Here", name: 'register');
  }

  String get logInAsDriver {
    return Intl.message('Are you a driver? LogIn as Driver',
        name: 'logInAsDriver');
  }

  //RegisterScreen
  //Validations
  String get nameValidation {
    return Intl.message('Name must be at least 3 characters',
        name: 'nameValidation');
  }

  String get phoneNotValid {
    return Intl.message('Phone number is not valid', name: 'phoneNotValid');
  }

  String get passwordCharacters {
    return Intl.message('Password must have at least 8 characters',
        name: 'passwordCharacters');
  }

  String get passwordsNotMatch {
    return Intl.message("Passwords do not match", name: 'passwordsNotMatch');
  }

  String get accountCreated {
    return Intl.message('Account has been created', name: 'accountCreated');
  }

  String get accountNotCreated {
    return Intl.message('Account has not been created',
        name: 'accountNotCreated');
  }

  //Fields
  String get registerHeader {
    return Intl.message('Register', name: 'registerHeader');
  }

  String get name {
    return Intl.message('Name', name: 'name');
  }

  String get phone {
    return Intl.message('Phone', name: 'phone');
  }

  String get confirmPassword {
    return Intl.message("Confirm Password", name: 'confirmPassword');
  }

  String get createAccountButton {
    return Intl.message('Create Account', name: 'createAccountButton');
  }

  String get loginHere {
    return Intl.message('Already have an account? Login Here',
        name: 'loginHere');
  }

  //Nearest Drivers
  String get nearestOnlineDrivers {
    return Intl.message('Nearest Online Drivers', name: 'nearestOnlineDrivers');
  }

  String get cancelRideRequest {
    return Intl.message('Ride Request Cancelled', name: 'cancelRideRequest');
  }

  //Drivers App
  //Main Screen
  String get home {
    return Intl.message('Home', name: 'home');
  }

  String get earnings {
    return Intl.message('Earnings', name: 'earnings');
  }

  String get ratings {
    return Intl.message('Ratings', name: 'ratings');
  }

  String get account {
    return Intl.message("Account", name: 'account');
  }

  //Car Info
  String get carDetails {
    return Intl.message('Car Details', name: 'carDetails');
  }

  String get carDetailsSaved {
    return Intl.message('Car details successfully saved',
        name: 'carDetailsSaved');
  }

  String get carModel {
    return Intl.message('Car Model', name: 'carModel');
  }

  String get carNumber {
    return Intl.message('Car Plate', name: 'carNumber');
  }

  String get carColor {
    return Intl.message("Car Color", name: 'carColor');
  }

  String get carType {
    return Intl.message('Car Type', name: 'carType');
  }

  String get saveNowButton {
    return Intl.message('Save Now', name: 'saveNowButton');
  }

  //Login
  String get loginAsUser {
    return Intl.message('Login as User', name: 'loginAsUser');
  }

  //Language
  String get languageSettings {
    return Intl.message('Language Settings', name: 'languageSettings');
  }

  //Home Tab Page
  String get nowOffline {
    return Intl.message('Now Offline', name: 'nowOffline');
  }

  String get nowOfflineMessage {
    return Intl.message('You Are Offline Now', name: 'nowOfflineMessage');
  }

  String get nowOnline {
    return Intl.message('Now Online', name: 'nowOnline');
  }

  String get nowOnlineMessage {
    return Intl.message('You Are Online Now', name: 'nowOnlineMessage');
  }

  //Push Notification
  String get newRide {
    return Intl.message("New Ride Request", name: 'newRide');
  }

  String get rideNotExists {
    return Intl.message("This Ride Request Not Exists", name: 'rideNotExists');
  }

  String get cancel {
    return Intl.message("Cancel", name: 'cancel');
  }

  String get accept {
    return Intl.message("Accept", name: 'accept');
  }

  //Chat
  String get messaging {
    return Intl.message("Messaging", name: 'messaging');
  }

  String get sayHi {
    return Intl.message("Say Hi", name: 'sayHi');
  }

  String get noChatsAvailable {
    return Intl.message("No Chats Available", name: 'noChatsAvailable');
  }

  String get typeUsername {
    return Intl.message("Type Username...", name: 'typeUsername');
  }

  String get friends {
    return Intl.message("Friends", name: 'friends');
  }

  String get noFriends {
    return Intl.message("No Friends Added Yet", name: 'noFriends');
  }

  //Video Call

  String get videoCall {
    return Intl.message("Video Call", name: 'videoCall');
  }

  String get waitUserToJoin {
    return Intl.message("Waiting for user to join", name: 'waitUserToJoin');
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}
