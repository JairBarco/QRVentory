import 'package:flutter/material.dart';

import 'package:users_app/users/en/app_localization/app_localization.dart';

import '../splashScreen/splash_screen.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //Search place UI
          Container(
            height: MediaQuery.of(context).size.height * .40,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),
                      Center(
                        child: Text(
                          AppLocalization.of(context)!.languageSettings,
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                AppLocalization.load(const Locale('es', 'MX'));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const MySplashScreen()));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            child: const Text("Español"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                AppLocalization.load(const Locale('en', 'US'));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const MySplashScreen()));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            child: const Text("English"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                AppLocalization.load(const Locale('de', ''));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            const MySplashScreen()));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            child: const Text("Deutsch"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
