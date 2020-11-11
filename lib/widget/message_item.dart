import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/chat/message.dart';
import 'package:nfl_app/utils/constants.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final String image;

  const MessageItem({Key key, this.message, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(message.isMe ? 1 : -1, 0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .8,
          minWidth: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!message.isMe)
              Container(
                height: 60,
                width: 40,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 30,
                      ),
                    ),
                    if (message.date != null)
                      FittedBox(
                        child: Text(
                          DateFormat("h:mm a").format(message.date),
                        ),
                      ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color:
                    message.isMe ? Constants.lightBrown : Constants.lightGreen,
                borderRadius: BorderRadius.circular(200).subtract(
                  BorderRadius.only(
                    bottomLeft: message.isMe
                        ? Radius.circular(0)
                        : Radius.circular(200),
                    bottomRight: message.isMe
                        ? Radius.circular(200)
                        : Radius.circular(0),
                  ),
                ),
              ),
              child: Text(
                message.typing ? "..." : message.text,
                style: TextStyle(
                  color: message.isMe ? Constants.brown : Constants.darkGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
