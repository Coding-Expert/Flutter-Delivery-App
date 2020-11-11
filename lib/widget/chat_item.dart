import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:nfl_app/models/chat/chat.dart';
import 'package:nfl_app/screens/messages/Chat_screen.dart';
import 'package:nfl_app/utils/constants.dart';

class ChatItem extends StatefulWidget {
  final Chat chat;

  const ChatItem({Key key, this.chat}) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
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
    return Slidable(
      key: GlobalKey(),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chat: widget.chat),
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            widget.chat.web.imageUrl ?? "",
          ),
        ),
        title: Text(widget.chat.web.name ?? widget.chat.web.phone),
        subtitle: Text(
          widget.chat.messages.isNotEmpty
              ? widget.chat?.messages?.first?.text ?? ""
              : "",
          style: Constants.lightTextLarge,
        ),
        trailing: Text(
          calcTime(widget.chat.messages.isNotEmpty
              ? widget.chat?.messages?.first?.date
              : null),
          style: Constants.lightTextSmall,
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        Container(
          color: Constants.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.more_horiz, color: Colors.black),
              Text(
                "More",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        Container(
          color: Constants.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  String calcTime(DateTime date) {
    if (date == null) return "";
    var n = DateTime.now();
    DateTime today = DateTime(n.year, n.month, n.day);

    if (date.isAfter(today)) return DateFormat("h:mm a").format(date);
    if (date.difference(today).abs() < Duration(days: 1)) return "Yesterday";
    if (date.difference(today).abs() < Duration(days: 7))
      return DateFormat("EEEE").format(date);
    return DateFormat.MMMMd().format(date);
  }
}
