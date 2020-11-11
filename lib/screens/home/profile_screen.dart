import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/utils/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:device_id/device_id.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = UserModel.user;

  bool uploading = false;
  String user_image = null;
  TextEditingController phone_controller = TextEditingController(text: "");
  TextEditingController address_controller = TextEditingController(text: "");
  TextEditingController driverid_controller = TextEditingController(text: "");
  TextEditingController email_controller = TextEditingController(text: "");
  TextEditingController driver_lisence_controller = TextEditingController(text: "");
  TextEditingController truckModel_controller = TextEditingController(text: "");
  TextEditingController truckNumber_controller = TextEditingController(text: "");
  TextEditingController duty_controller = TextEditingController(text: "");
  TextEditingController drivingSince_controller = TextEditingController(text: "");
  final FocusNode phone_focus = FocusNode();
  final FocusNode address_focus = FocusNode();
  final FocusNode driverid_focus = FocusNode();
  final FocusNode email_focus = FocusNode();
  final FocusNode driverLisence_focus = FocusNode();
  final FocusNode truckModel_focus = FocusNode();
  final FocusNode truckNumber_focus = FocusNode();
  final FocusNode duty_focus = FocusNode();
  final FocusNode drivingSince_focus = FocusNode();

  static const _placeHolder = "xxx xxx";
  String deviceId = "";
  bool edit_flag = false;

  @override
  initState(){
    super.initState();
    
    user_image = user.imageUrl;
    phone_controller.text = user.phone;
    address_controller.text = user.address;
    driverid_controller.text = user.id.toString();
    email_controller.text = user.email;
    driver_lisence_controller.text = user.license;
    truckModel_controller.text = user.truckModel;
    truckNumber_controller.text = user.truckNumber;
    duty_controller.text = user.duty;
    drivingSince_controller.text = user.drivingSince;
  }
  Future<String> getDeviceID()  async {
    return await DeviceId.getID;
  }

  Widget item(String field, Widget data) {
    return Container(
      padding: EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //     border: Border(
      //   bottom: BorderSide(color: Colors.black12),
      // )),
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Text(
              field,
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: data,
            flex: 2,
          ),
        ],
      ),
    );
  }
  logout(BuildContext context) async {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.remove("number");
    Navigator.pushReplacementNamed(context, "/");
  }
  verifyDevice(BuildContext context){
    getDeviceID().then((id){
      UserModel.verifyDevice(id).then((value){
        if(value == "0"){
          logout(context);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    verifyDevice(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VerticalDivider(),
            GestureDetector(
              onTap: uploadImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    user_image == null ? null : NetworkImage(user_image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: uploading
                  // ? SpinKitFadingCube(
                  //     color: Constants.darkGreen,
                  //   )
                  ?  Image.asset("assets/images/itruck-loader.gif", width: 60, height: 60)
                  : GestureDetector(
                      onTap: (){
                        setState(() {
                          if(edit_flag){
                            edit_flag = false;
                          }
                          else{
                            edit_flag = true;
                          }
                        });
                      },
                      child: Image.asset(
                        "assets/images/edit.png",
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            user.name ?? _placeHolder,
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),
        ),
        item(
          "Phone",
          TextFormField(
            controller: phone_controller,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.black),
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Address",
          TextFormField(
            controller: address_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Driving for",
          TextFormField(
            controller: driverid_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Email",
          TextFormField(
            controller: email_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Driving license NO",
          TextFormField(
            controller: driver_lisence_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Truck Model",
          TextFormField(
            controller: truckModel_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Truck number",
          TextFormField(
            controller: truckNumber_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Duty Class",
          TextFormField(
            controller: duty_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        item(
          "Driving Since",
          TextFormField(
            controller: drivingSince_controller,
            keyboardType: TextInputType.text,
            style: Constants.darkText,
            // decoration: InputDecoration(
            //   border: !edit_flag ? InputBorder.none : UnderlineInputBorder(),
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enabled: edit_flag ? true : false,
          )
        ),
        Divider(
          color: Colors.grey,
          height: 0
        ),
        // item(
        //   "Endorsments",
        //   Row(
        //     children: [
        //       Image.asset(
        //         "assets/images/truck.png",
        //         height: 50,
        //       ),
        //       SizedBox(width: 15),
        //       Image.asset(
        //         "assets/images/hazmat.png",
        //         height: 30,
        //       ),
        //       SizedBox(width: 15),
        //       Image.asset(
        //         "assets/images/flammable.png",
        //         height: 40,
        //       ),
        //     ],
        //   ),
        // ),
        Padding(padding: EdgeInsets.only(top: 50)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                child: new RaisedButton(
                  onPressed: () {
                    editProfile();
                  },
                  child: Text('SUBMIT', style: TextStyle(fontSize: 18),),
                  textColor: Colors.white,
                  color: Constants.lightGreen,
                    
                ),
              ),
          ],
        )
      ],
    );
  }

  void uploadImage() async {
    setState(() => uploading = true);
    UserModel.uploadImage().then((value){
      Map res = jsonDecode(value.body);
      setState(() {
        uploading = false;
        user_image = "https://www.itruckdispatch.com/" + res["response"]["img"];
      });
    }
    );
  }
  void editProfile(){
    if(phone_controller == null || phone_controller.text.isEmpty){
      Toast.show("input phone number", context);
      return;
    }
    if(address_controller == null || address_controller.text.isEmpty){
      Toast.show("input address", context);
      return;
    }
    if(driverid_controller == null || driverid_controller.text.isEmpty){
      Toast.show("input driverId", context);
      return;
    }
    if(email_controller == null || email_controller.text.isEmpty){
      Toast.show("input email", context);
      return;
    }
    if(driver_lisence_controller == null || driver_lisence_controller.text.isEmpty){
      Toast.show("input driver lisence", context);
      return;
    }
    if(truckModel_controller == null || truckModel_controller.text.isEmpty){
      Toast.show("input truck model", context);
      return;
    }
    if(truckNumber_controller == null || truckNumber_controller.text.isEmpty){
      Toast.show("input truck number", context);
      return;
    }
    if(duty_controller == null || duty_controller.text.isEmpty){
      Toast.show("input duty class", context);
      return;
    }
    if(drivingSince_controller == null || drivingSince_controller.text.isEmpty){
      Toast.show("input driving date", context);
      return;
    }
    String driverid = driverid_controller.text;
    String drivingSince = drivingSince_controller.text;
    String phone = phone_controller.text;
    String duty = duty_controller.text;
    String truckNumber = truckNumber_controller.text;
    String truckModel = truckModel_controller.text;
    String lisence = driver_lisence_controller.text;
    String email = email_controller.text;
    String name = user.name;
    String address = address_controller.text;
    setState(() => uploading = true);
    UserModel.editProfile(driverid, drivingSince, phone, duty, truckNumber, truckModel, lisence, email, name, address).then((value){
      if(value == 200){
        setState(() {
          uploading = false;
        });
        Toast.show("Data has saved successfully!", context);
      }
    })
    .catchError((err) {
      setState(() {
          uploading = false;
      });
      Toast.show("Data saving failed!", context);
    });
  }
}
