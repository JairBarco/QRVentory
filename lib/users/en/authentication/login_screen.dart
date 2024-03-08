import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/users/en/authentication/signup_screen.dart';
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

  Future<bool> loginUserNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(
          message: "Por favor, espere...",
        );
      },
    );

    try {
      final UserCredential userCredential = await fAuthUser.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
        final driverKey = await driversRef.child(firebaseUser.uid).once();
        final snap = driverKey.snapshot;

        if (firebaseUser.emailVerified == true) {
          if (snap.value != null) {
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: "Inicio de sesión exitoso");
            return true;
          }
        } else {
          Fluttertoast.showToast(msg: "Correo electrónico no verificado");

          if (snap.value == null) {
            Fluttertoast.showToast(msg: "Correo electrónico no registrado");
            fAuthUser.signOut();
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Ocurrió un error durante el inicio de sesión");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      Navigator.pop(context);
    }

    return false;
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("img/logo.png"),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Iniciar sesión",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  hintText: "Correo electrónico",
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
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
                style: const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  hintText: "Contraseña",
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  loginUserNow().then((success) {
                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => const MySplashScreen()),
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text(
                  "Iniciar Sesión",
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),
              TextButton(
                child: Text(
                  "Registrarse",
                  style: const TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}