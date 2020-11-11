import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfl_app/models/chat/chat.dart';
import 'package:nfl_app/models/chat/chat_bloc.dart';
import 'package:nfl_app/models/chat/message.dart';
import 'package:nfl_app/models/user_model.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';
import 'package:nfl_app/widget/my_drawer_widget.dart';

import 'chat_content.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat;

  ChatScreen({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<ChatBloc>(context).setNotTyping(chat);
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            alignment: Alignment.topLeft,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBarWidget(context: context, title: "Messages"),
          endDrawer: MyDrawerWidget(),
          body: ChatContent(chat: chat),
          bottomSheet: bottomMessageSender(context),
        ),
      ),
    );
  }

  final TextEditingController controller = TextEditingController();
  bottomMessageSender(BuildContext context) => Container(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (value) => sendMessage(context),
                onChanged: (val) async {
                  if (val.isEmpty) {
                    BlocProvider.of<ChatBloc>(context).setNotTyping(chat);
                  } else {
                    if (!chat.messages.any((element) =>
                        element.typing == true &&
                        element.sender == UserModel.user.phone))
                      BlocProvider.of<ChatBloc>(context).setTyping(chat);
                  }
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  border: InputBorder.none,
                  labelText: "Your Message ...",
                ),
              ),
            ),
            GestureDetector(
              onTap: () => sendMessage(context),
              child: Container(
                width: 60,
                color: Colors.green,
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );

  void sendMessage(BuildContext context) {
    BlocProvider.of<ChatBloc>(context).mapSendMessage(
      Message(
        date: DateTime.now(),
        text: controller.text,
        sender: UserModel.user.phone,
      ),
      chat,
    );

    controller.text = "";
  }
}
