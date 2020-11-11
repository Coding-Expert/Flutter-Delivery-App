import 'package:flutter/material.dart';
import 'package:nfl_app/models/chat/chat.dart';
import 'package:nfl_app/widget/message_item.dart';

class ChatContent extends StatefulWidget {
  final Chat chat;

  const ChatContent({Key key, this.chat}) : super(key: key);

  @override
  _ChatContentState createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  void onChange() {
    setState(() {});
  }

  @override
  void initState() {
    widget.chat.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.chat.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 80),
      children: widget.chat.messages
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: MessageItem(
                  message: e,
                  image: widget.chat.web.imageUrl ?? "",
                ),
              ))
          .toList(),
    );
  }
}
