import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:nfl_app/models/user_model.dart';

class RedirectScreen extends StatefulWidget {
  @override
  _RedirectScreenState createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {

  String deviceId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    StoreRedirect.redirect(
        androidAppId: "com.crinoid.breakdown", iOSAppId: "1459289134");
  }
  Future<String> getDeviceID()  async {
    return await DeviceId.getID;
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
    return Container(
      child: Center(
          //child: CircularProgressIndicator(),
          ),
    );
  }
}
