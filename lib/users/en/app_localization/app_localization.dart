import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../generated/intl/messages_all.dart';

class AppLocalization {

  static Future<AppLocalization> load(Locale locale) {
    final String name = locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
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
    return Intl.message(
      'From',
      name: 'From'
    );
  }
  String get to {
    return Intl.message(
        'To',
        name: 'To'
    );
  }
  String get originLocation {
    return Intl.message(
        'Origin Location',
        name: 'originLocation'
    );
  }
  String get notGettingAddressWarning {
    return Intl.message(
        'Not Getting Address',
        name: 'notGettingAddressWarning'
    );
  }
  String get dropOffLocation {
    return Intl.message(
        'Search DropOff Locations',
        name: 'dropOffLocation'
    );
  }
  String get requestRideButton {
    return Intl.message(
        'Request a Ride',
        name: 'requestRideButton'
    );
  }

  //Drawer
  String get yourName {
    return Intl.message(
        'Your Name',
        name: 'yourName'
    );
  }
  String get yourEmail {
    return Intl.message(
        'Your e-mail',
        name: 'yourEmail'
    );
  }
  String get history {
    return Intl.message(
        'History',
        name: 'history'
    );
  }
  String get profile {
    return Intl.message(
        'Profile',
        name: 'profile'
    );
  }
  String get driver {
    return Intl.message(
        'Driver',
        name: 'driver'
    );
  }
  String get language {
    return Intl.message(
        'Language',
        name: 'language'
    );
  }
  String get help {
    return Intl.message(
        'Help',
        name: 'help'
    );
  }
  String get logOut {
    return Intl.message(
        'Log Out',
        name: 'logOut'
    );
  }

  //Progress Dialog
  String get progressDialog {
    return Intl.message(
        'Please Wait...',
        name: 'progressDialog'
    );
  }

}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => ['en', 'es_MX', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}