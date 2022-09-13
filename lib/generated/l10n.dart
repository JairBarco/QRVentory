// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get From {
    return Intl.message(
      'From',
      name: 'From',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get To {
    return Intl.message(
      'To',
      name: 'To',
      desc: '',
      args: [],
    );
  }

  /// `Origin Location`
  String get originLocation {
    return Intl.message(
      'Origin Location',
      name: 'originLocation',
      desc: '',
      args: [],
    );
  }

  /// `Not Getting Address`
  String get notGettingAddressWarning {
    return Intl.message(
      'Not Getting Address',
      name: 'notGettingAddressWarning',
      desc: '',
      args: [],
    );
  }

  /// `Search DropOff Locations`
  String get dropOffLocation {
    return Intl.message(
      'Search DropOff Locations',
      name: 'dropOffLocation',
      desc: '',
      args: [],
    );
  }

  /// `Request a Ride`
  String get requestRideButton {
    return Intl.message(
      'Request a Ride',
      name: 'requestRideButton',
      desc: '',
      args: [],
    );
  }

  /// `Your Name`
  String get yourName {
    return Intl.message(
      'Your Name',
      name: 'yourName',
      desc: '',
      args: [],
    );
  }

  /// `Your e-mail`
  String get yourEmail {
    return Intl.message(
      'Your e-mail',
      name: 'yourEmail',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Driver`
  String get driver {
    return Intl.message(
      'Driver',
      name: 'driver',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Search & Set Drop off Location`
  String get searchHeader {
    return Intl.message(
      'Search & Set Drop off Location',
      name: 'searchHeader',
      desc: '',
      args: [],
    );
  }

  /// `Search Here...`
  String get search {
    return Intl.message(
      'Search Here...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Please Wait...`
  String get progressDialog {
    return Intl.message(
      'Please Wait...',
      name: 'progressDialog',
      desc: '',
      args: [],
    );
  }

  /// `Email is Mandatory`
  String get emailMandatory {
    return Intl.message(
      'Email is Mandatory',
      name: 'emailMandatory',
      desc: '',
      args: [],
    );
  }

  /// `Email is not valid`
  String get emailNotValid {
    return Intl.message(
      'Email is not valid',
      name: 'emailNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordIsRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Login Successful`
  String get loginSuccessful {
    return Intl.message(
      'Login Successful',
      name: 'loginSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Email not verified`
  String get emailNotVerified {
    return Intl.message(
      'Email not verified',
      name: 'emailNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `No record exists with this email`
  String get noRecordExistsWithThisEmail {
    return Intl.message(
      'No record exists with this email',
      name: 'noRecordExistsWithThisEmail',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred during Login`
  String get errorDuringLogin {
    return Intl.message(
      'Error occurred during Login',
      name: 'errorDuringLogin',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButton {
    return Intl.message(
      'Login',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? SignUp Here`
  String get register {
    return Intl.message(
      'Don\'t have an account? SignUp Here',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Are you a driver? LogIn as Driver`
  String get logInAsDriver {
    return Intl.message(
      'Are you a driver? LogIn as Driver',
      name: 'logInAsDriver',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters`
  String get nameValidation {
    return Intl.message(
      'Name must be at least 3 characters',
      name: 'nameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is not valid`
  String get phoneNotValid {
    return Intl.message(
      'Phone number is not valid',
      name: 'phoneNotValid',
      desc: '',
      args: [],
    );
  }

  /// `Password must have at least 8 characters`
  String get passwordCharacters {
    return Intl.message(
      'Password must have at least 8 characters',
      name: 'passwordCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Account has been created`
  String get accountCreated {
    return Intl.message(
      'Account has been created',
      name: 'accountCreated',
      desc: '',
      args: [],
    );
  }

  /// `Account has not been created`
  String get accountNotCreated {
    return Intl.message(
      'Account has not been created',
      name: 'accountNotCreated',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerHeader {
    return Intl.message(
      'Register',
      name: 'registerHeader',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccountButton {
    return Intl.message(
      'Create Account',
      name: 'createAccountButton',
      desc: '',
      args: [],
    );
  }

  /// `Have an account? Login Here`
  String get loginHere {
    return Intl.message(
      'Have an account? Login Here',
      name: 'loginHere',
      desc: '',
      args: [],
    );
  }

  /// `Car details successfully saved`
  String get carDetailsSaved {
    return Intl.message(
      'Car details successfully saved',
      name: 'carDetailsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get languageSettings {
    return Intl.message(
      'Language Settings',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `Now Offline`
  String get nowOffline {
    return Intl.message(
      'Now Offline',
      name: 'nowOffline',
      desc: '',
      args: [],
    );
  }

  /// `You Are Offline Now`
  String get nowOfflineMessage {
    return Intl.message(
      'You Are Offline Now',
      name: 'nowOfflineMessage',
      desc: '',
      args: [],
    );
  }

  /// `Now Online`
  String get nowOnline {
    return Intl.message(
      'Now Online',
      name: 'nowOnline',
      desc: '',
      args: [],
    );
  }

  /// `You Are Online Now`
  String get nowOnlineMessage {
    return Intl.message(
      'You Are Online Now',
      name: 'nowOnlineMessage',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Earnings`
  String get earnings {
    return Intl.message(
      'Earnings',
      name: 'earnings',
      desc: '',
      args: [],
    );
  }

  /// `Ratings`
  String get ratings {
    return Intl.message(
      'Ratings',
      name: 'ratings',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Login as User`
  String get loginAsUser {
    return Intl.message(
      'Login as User',
      name: 'loginAsUser',
      desc: '',
      args: [],
    );
  }

  /// `Nearest Online Drivers`
  String get nearestOnlineDrivers {
    return Intl.message(
      'Nearest Online Drivers',
      name: 'nearestOnlineDrivers',
      desc: '',
      args: [],
    );
  }

  /// `Ride Request Cancelled`
  String get cancelRideRequest {
    return Intl.message(
      'Ride Request Cancelled',
      name: 'cancelRideRequest',
      desc: '',
      args: [],
    );
  }

  /// `New Ride Request`
  String get newRide {
    return Intl.message(
      'New Ride Request',
      name: 'newRide',
      desc: '',
      args: [],
    );
  }

  /// `This Ride Request Not Exists`
  String get rideNotExists {
    return Intl.message(
      'This Ride Request Not Exists',
      name: 'rideNotExists',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
