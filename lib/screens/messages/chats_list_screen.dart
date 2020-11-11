import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfl_app/models/chat/chat_bloc.dart';
import 'package:nfl_app/models/chat/chat_utils.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/widget/chat_item.dart';
import 'package:device_id/device_id.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsListScreen extends StatelessWidget {

  String deviceId = "";

  @override
  void initState() {
    
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
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatStateDone)
          return ListView(
            children: state.chats
                .map(
                  (e) => ChatItem(chat: e),
                )
                .toList(),
          );
        else
          return Center(
            child: SpinKitCubeGrid(
              color: Constants.orange,
            ),
          );
      },
    );
  }
}
