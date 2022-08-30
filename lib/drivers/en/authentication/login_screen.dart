
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/drivers/en/authentication/signup_screen.dart';
import 'package:users_app/users/en/authentication/login_screen.dart';
import '../../../drivers/en/global/global.dart';
import '../../../users/en/app_localization/app_localization.dart';
import '../../../users/en/widgets/progress_dialog.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/language.dart';

class DriversLoginScreen extends StatefulWidget {

  @override
  State<DriversLoginScreen> createState() => _DriversLoginScreenState();
}

class _DriversLoginScreenState extends State<DriversLoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm(){
    validateEmail(String value) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);
      if (value.isEmpty) {
        Fluttertoast.showToast(msg: AppLocalization.of(context)!.emailMandatory);
      } else if (!regExp.hasMatch(value)) {
        Fluttertoast.showToast(msg: AppLocalization.of(context)!.emailNotValid);
      }
    }

    if(!emailTextEditingController.text.contains("@") || emailTextEditingController.text.isEmpty){
      validateEmail(emailTextEditingController.text);
    }
    if(passwordTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.passwordIsRequired);
    }else{
      loginDriverNow();
    }
  }

  loginDriverNow() async {
    final navigator = Navigator.of(context);
    final navigatorPush = Navigator.push(context, MaterialPageRoute(builder: (c) =>const DriversSplashScreen()));

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: AppLocalization.of(context)!.progressDialog,);
        }
    );

    final User? firebaseDriver = (
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error:  ${msg.toString()}");
        })
    ).user;

    if(firebaseDriver !=null){
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseDriver.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if(snap.value != null){
        currentFirebaseDriver = firebaseDriver;
        Fluttertoast.showToast(msg: AppLocalization.of(context)!.loginSuccessful);
        navigatorPush;
      } else {
          Fluttertoast.showToast(msg: AppLocalization.of(context)!.noRecordExistsWithThisEmail);
          fAuth.signOut();
          navigatorPush;
        }
      });
    } else {
      navigator.pop();
      if(!mounted) return;
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.errorDuringLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("img/logo1.png"),
              ),

              const SizedBox(height: 10,),
              Text(AppLocalization.of(context)!.login, style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.email,
                  hintText: AppLocalization.of(context)!.email,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,

                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.password,
                  hintText: AppLocalization.of(context)!.password,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (){
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text(
                  AppLocalization.of(context)!.loginButton,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18
                  ),
                ),
              ),

               TextButton(
                child: Text(AppLocalization.of(context)!.register,
                style: const TextStyle(color: Colors.grey),
                ),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const DriversSignUpScreen()));
                 },
              ),

              TextButton(
                child: Text(AppLocalization.of(context)!.loginAsUser,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  fAuth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),
              TextButton(
                child: Text(AppLocalization.of(context)!.language,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => DriversLanguageScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
