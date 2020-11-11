import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initApp(context);
    return Container(
      color: Colors.white,
      child: Center(
        // child: Image.asset(
        //   "assets/images/itruck-loader.gif",
        //   fit: BoxFit.contain,
        //   width: 50,
        //   height: 50,
        // ),
      ),
    );
  }

  void initApp(BuildContext context) async {
    Firebase.initializeApp();
    UserModel.init().then((value) async {
      if (UserModel.user != null) {
        //todo
        //if (UserModel.user == null) {
        //todo

        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    }).catchError((err) {
      Navigator.pushReplacementNamed(context, "/login"); //todo

      ///  /login..//todo
    });
  }
}
