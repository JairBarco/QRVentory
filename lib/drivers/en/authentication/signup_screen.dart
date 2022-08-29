import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import '../../../drivers/en/global/global.dart';
import 'car_info.dart';
import 'login_screen.dart';

class DriversSignUpScreen extends StatefulWidget {
  const DriversSignUpScreen({Key? key}) : super(key: key);

  @override
  State<DriversSignUpScreen> createState() => _DriversSignUpScreenState();
}

class _DriversSignUpScreenState extends State<DriversSignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();

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

    if(nameTextEditingController.text.length < 3){
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.nameValidation);
    }
    else if(!emailTextEditingController.text.contains("@") || emailTextEditingController.text.isEmpty){
      validateEmail(emailTextEditingController.text);
    }
    else if(phoneTextEditingController.text.length < 10){
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.phoneNotValid);
    }
    else if(passwordTextEditingController.text.length < 8){
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.passwordCharacters);
    }else if(passwordTextEditingController.text != confirmPasswordTextEditingController.text){
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.passwordsNotMatch);
    }
    else{
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async {
    final navigator = Navigator.of(context);
    final navigatorPush = Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));

    final User? firebaseDriver = (
         await fAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error:  ${msg.toString()}");
        })
    ).user;

    if(firebaseDriver !=null){
      Map driverMap = {
        "id": firebaseDriver.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseDriver.uid).set(driverMap);

      currentFirebaseDriver = firebaseDriver;
      firebaseDriver.sendEmailVerification();
      if(!mounted) return;
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.accountCreated);
      navigatorPush;
    } else {
      navigator.pop();
      if(!mounted) return;
      Fluttertoast.showToast(msg: AppLocalization.of(context)!.accountNotCreated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("img/logo1.png"),
              ),
              const SizedBox(height: 10,),

              Text(AppLocalization.of(context)!.registerHeader, style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),),

              TextField(
                controller: nameTextEditingController,
                  style: const TextStyle(
                    color:Colors.grey
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalization.of(context)!.name,
                    hintText: AppLocalization.of(context)!.name,
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.phone,
                  hintText: AppLocalization.of(context)!.phone,
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

              TextField(
                controller: confirmPasswordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,

                style: const TextStyle(
                    color:Colors.grey
                ),
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.confirmPassword,
                  hintText: AppLocalization.of(context)!.confirmPassword,
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
                  AppLocalization.of(context)!.createAccountButton,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18
                  ),
                ),
              ),

              TextButton(
                child: Text(AppLocalization.of(context)!.loginHere,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => DriversLoginScreen()));
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
