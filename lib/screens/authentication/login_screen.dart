import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:toast/toast.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void submitNumber() {
    if(number.text == null || number.text.isEmpty){
      Toast.show("please enter your registered number", context);
      return;
    }
    UserModel.sendOtpToNumber("${number.text.replaceAll(" ", "")}")
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          error = "please try again";
        });
      } else {
        Navigator.pushReplacementNamed(context, "/code");
      }
    }).catchError((e) {
      Toast.show("invalid number", context);
    });
  }

  TextEditingController number = TextEditingController(text: "");
  TextEditingController prefix = TextEditingController(text: "1");
  String error;

  @override
  void initState() {
    super.initState();
  }
  
  void init([bool second = false]) async {
    await MobileNumber.requestPhonePermission;
    var sims = await MobileNumber.getSimCards;
    if (sims.length > 0) {
      var sim = sims.first;
      setState(() {
        number.text = sim.number
            .replaceFirst("+", "")
            .replaceFirst(sim.countryPhonePrefix, "");
        prefix.text = sim.countryPhonePrefix;
      });
    }
  }

  Expanded get padding => Expanded(child: SizedBox());

  @override
  Widget build(BuildContext context) {
    if (number.text.isEmpty) {
      init();
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/background.png",
            alignment: Alignment.topLeft,
          ),
          Transform.rotate(
            angle: pi,
            child: Image.asset(
              "assets/images/background.png",
              alignment: Alignment.topLeft,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Image.asset("assets/images/logo1.png",
                        width: 150, height: 150),
                  ),
                ),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, color: Color(0xff767272)),
                ),
                SizedBox(height: 20),
                Text(
                  "Please enter your phone number \n to receive a verification code.\nCarrier rates may be apply",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xff767272)),
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: TextFormField(
                        controller: prefix,
                        enabled: false,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(prefixIcon: Icon(Icons.add)),
                        style: TextStyle(color: Colors.black45),
                      ),
                      width: 100,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        onFieldSubmitted: (value) => submitNumber(),
                        controller: number,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorText: error,
                          border: UnderlineInputBorder(
                            borderSide: const BorderSide(width: .5),
                          ),
                        ),
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    colorBrightness: Brightness.dark,
                    child: Text("CONTINUE"),
                    onPressed: submitNumber,
                    color: Constants.lightRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)),
                  ),
                ),
//            SizedBox(height: 10),
//            Text("or sign in using"),
//            SizedBox(height: 20),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Image.asset("assets/images/fblogo.png", width: 30, height: 30),
//                SizedBox(width: 20),
//                Image.asset("assets/images/glogo.png", width: 30, height: 30),
//              ],
//            ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
