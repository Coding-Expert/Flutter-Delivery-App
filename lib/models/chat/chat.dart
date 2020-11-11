import 'package:flutter/material.dart';
import 'package:nfl_app/models/chat/message.dart';
import 'package:nfl_app/utils/user.dart';

class Chat extends ChangeNotifier {
  final String id;
  final User web;
  List<Message> messages = [];

  Chat({
    this.id,
    Stream<List<Message>> messages,
    this.web,
  }){
    messages.listen((event) {
      this.messages = event;
      notifyListeners();
    });
  }
}
