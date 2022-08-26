
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/drivers/en/authentication/signup_screen.dart';
import 'package:users_app/users/en/authentication/login_screen.dart';
import '../../../drivers/en/global/global.dart';
import '../../../users/en/widgets/progress_dialog.dart';
import '../splashScreen/splash_screen.dart';

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
        Fluttertoast.showToast(msg: "Email is mandatory");
      } else if (!regExp.hasMatch(value)) {
        Fluttertoast.showToast(msg: "Email is not valid");
      }
    }

    if(!emailTextEditingController.text.contains("@") || emailTextEditingController.text.isEmpty){
      validateEmail(emailTextEditingController.text);
    }
    if(passwordTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Password is required");
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
          return ProgressDialog(message: "Processing, please wait...",);
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
        Fluttertoast.showToast(msg: "Login Successful.");
        navigatorPush;
      } else {
          Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          navigatorPush;
        }
      });
    } else {
      navigator.pop();
      Fluttertoast.showToast(msg: "Error occurred during Login");
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
              const Text("Login", style: TextStyle(
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
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
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
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
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
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18
                  ),
                ),
              ),

               TextButton(
                child: const Text("Don't have an account? SignUp Here",
                style: TextStyle(color: Colors.grey),
                ),
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (c) => const DriversSignUpScreen()));
                 },
              ),

              TextButton(
                child: const Text("LogIn as User",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
