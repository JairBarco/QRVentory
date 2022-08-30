import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/drivers/en/authentication/login_screen.dart';
import 'package:users_app/users/en/app_localization/app_localization.dart';
import 'package:users_app/users/en/authentication/signup_screen.dart';
import 'package:users_app/users/en/widgets/language.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      loginUserNow();
    }
  }

  loginUserNow() async {
    final navigator = Navigator.of(context);
    final navigatorPush = Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: AppLocalization.of(context)!.progressDialog,);
        }
    );

    final User? firebaseUser = (
        await fAuthUser.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error:  ${msg.toString()}");
        })
    ).user;

    if(firebaseUser !=null){
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if(firebaseUser.emailVerified == true){
          if(snap.value != null){
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: AppLocalization.of(context)!.loginSuccessful);
            navigatorPush;
          }
        } else if(firebaseUser.emailVerified == false){
          Fluttertoast.showToast(msg: AppLocalization.of(context)!.emailNotVerified);

          if(snap.value == null){
            Fluttertoast.showToast(msg: AppLocalization.of(context)!.noRecordExistsWithThisEmail);
            fAuthUser.signOut();
            navigatorPush;
          }
          fAuthUser.signOut();
          navigatorPush;
        }
      });
    } else {
      navigator.pop();
      if (!mounted) return;
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
                child: Image.asset("img/logo.png"),
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
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpScreen()));
                 },
              ),
              TextButton(
                child: Text(AppLocalization.of(context)!.logInAsDriver,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  fAuthUser.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => DriversLoginScreen()));
                },
              ),
              TextButton(
                child: Text(AppLocalization.of(context)!.language,
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LanguageScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
