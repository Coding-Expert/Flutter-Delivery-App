import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfl_app/models/chat/chat.dart';
import 'package:nfl_app/models/chat/chat_utils.dart';
import 'package:nfl_app/models/chat/message.dart';
import 'package:nfl_app/models/user_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(initialState) : super(initialState) {
    this.add(ChatEventLoadAll());
  }

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    print("event");
    if (event is ChatEventSendMessage) {
      mapSendMessage(event.message, event.chat);
      yield state;
    } else if (event is ChatEventLoadAll) {
      yield* getAll();
    } else if (event is ChatEventRemove) {
      mapRemoveChat(event.chatId);
      yield state;
    }
  }

  void mapSendMessage(Message message, Chat chat) {
    setNotTyping(chat);
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.id)
        .collection("Messages")
        .add(message.toMap);
  }

  Stream<ChatState> getAll() async* {
    yield ChatStateLoading();
    var snapshots = FirebaseFirestore.instance
        .collection("chats")
        .where("driver", isEqualTo: UserModel.user.phone)
        .snapshots();

    await for (var snap in snapshots) {
      List<Chat> chats = [];
      for (var doc in snap.docs) {
        var web = await UserModel.withPhone(doc.data()["web"]);
        Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
            .collection("chats")
            .doc(doc.id)
            .collection("Messages")
            .orderBy("date", descending: true)
            .snapshots();

        Stream<List<Message>> messages = messageStream.map((event) => event.docs
            .map(
              (e) => Message.fromMap(
                e.data(),
              ),
            )
            .toList());

        chats.add(
          Chat(
            id: doc.id,
            web: web,
            messages: messages,
          ),
        );
      }
      yield ChatStateDone(chats);
    }
  }

  void mapRemoveChat(String chatId) {
    FirebaseFirestore.instance.collection("chats").doc(chatId).delete();
  }

  void setTyping(Chat chat) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.id)
        .collection("Messages")
        .doc(UserModel.user.phone)
        .set(
          Message(
            sender: UserModel.user.phone,
            date: DateTime.now(),
            typing: true,
          ).toMap,
        );
  }

  Future setNotTyping(Chat chat) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.id)
        .collection("Messages")
        .doc(UserModel.user.phone)
        .delete();

//    await FirebaseFirestore.instance
//        .collection("chats")
//        .doc(chat.id)
//        .collection("Messages")
//        .where("typing", isEqualTo: true)
//        .get()
//        .then(
//      (value) async {
//        for (var element in value.docs) await element.reference.delete();
//      },
//    );
  }
}
