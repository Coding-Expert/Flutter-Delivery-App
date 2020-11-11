import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:device_id/device_id.dart';
import 'package:toast/toast.dart';

class CodeScreen extends StatefulWidget {
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {

  String error;
  String deviceId = "";
  final TextEditingController enteredCode = TextEditingController();

  verifyCode() {
    
    UserModel.checkCode(enteredCode.text).then((value) {
      UserModel.verifyDevice(deviceId).then((value){
        
        if(value == "1"){
          Navigator.pushReplacementNamed(context, "/home");
        }
        if(value == "0"){
          UserModel.updateDevice(deviceId).then((value){
            if(value == deviceId){
              Navigator.pushReplacementNamed(context, "/home");
            }
          });
        }
      });
      
    }).catchError((e) {
      Toast.show("${e.toString().split(":")[1]}", context);
    });
  }
  Future<String> getDeviceID()  async {
    return await DeviceId.getID;
  }

  @override
  void initState() {
    getDeviceID().then((value){
      deviceId =  value;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/logo1.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "Verify your number",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter your OTP code",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 30),
                PinFieldAutoFill(
                  keyboardType: TextInputType.number,
                  codeLength: 4,
                  controller: enteredCode,
                  decoration: UnderlineDecoration(
                    errorText: error,
                    colorBuilder: FixedColorBuilder(Color(0xff767272)),
                    obscureStyle: ObscureStyle(
                      isTextObscure: true,
                      obscureText: "\u{25CF}",
                    ),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    colorBrightness: Brightness.dark,
                    child: Text("VERIFY NOW"),
                    onPressed: () => verifyCode(),
                    color: Constants.lightRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
