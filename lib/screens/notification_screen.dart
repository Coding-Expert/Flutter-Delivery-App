import 'package:flutter/material.dart';
import 'package:nfl_app/utils/constants.dart';
import 'package:nfl_app/widget/my_appbar_widget.dart';

import 'package:time_formatter/time_formatter.dart' as time;

class NotificationScreen extends StatelessWidget {
  final List<MyNotification> notifications = [
//    NotificationMessage(sender: "ismael", date: DateTime.now()),
//    NotificationOrder(
//      from: "{santiago} ",
//      to: "{beken}",
//      date: DateTime.now().subtract(
//        Duration(minutes: 4),
//      ),
//    ),
//    NotificationMessage(
//      sender: "ismael",
//      date: DateTime.now().subtract(
//        Duration(days: 7),
//      ),
//    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(
        title: "Notifications",
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: notifications.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: notifications[index] is NotificationOrder
                    ? _buildOrderNotification(notifications[index])
                    : _buildMessageNotification(notifications[index]),
              ),
              Text(
                time.formatTime(
                  notifications[index].date.millisecondsSinceEpoch,
                ),
                style: Constants.lightTextSmall,
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  Widget _buildMessageNotification(NotificationMessage message) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: message.sender, style: Constants.blueText),
          TextSpan(text: " Sent you a message ", style: Constants.darkText),
        ],
      ),
    );
  }

  Widget _buildOrderNotification(NotificationOrder order) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "You got a new load from ${order.from} to ${order.to} ",
            style: Constants.darkText,
          ),
          TextSpan(text: " \nAccept the load", style: Constants.blueText),
        ],
      ),
    );
  }
}

abstract class MyNotification {
  final DateTime date;

  const MyNotification({this.date});
}

class NotificationMessage extends MyNotification {
  final String sender;

  NotificationMessage({this.sender, DateTime date}) : super(date: date);
}

class NotificationOrder extends MyNotification {
  final String from, to;

  NotificationOrder({this.from, this.to, DateTime date}) : super(date: date);
}
