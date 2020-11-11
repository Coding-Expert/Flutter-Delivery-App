import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfl_app/models/user_model.dart';

class Message {
  final String id;
  final String text;
  final bool typing;
  final DateTime date;
  final String sender;

  bool get isMe => sender == UserModel.user.phone;

  Message({
    this.text,
    this.id,
    this.typing = false,
    this.date,
    this.sender,
  });

  Message.fromMap(Map data)
      : this(
          text: data["text"],
          id: data["id"],
          typing: data["typing"] ?? false,
          date: (data["date"] as Timestamp).toDate(),
          sender: data["sender"],
        );

  Map get toMap => {
        "text": text,
        "typing": typing,
        "date": date,
        "sender": sender,
      }.cast<String, dynamic>();
}
