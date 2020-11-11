import 'package:equatable/equatable.dart';
import 'chat.dart';
import 'message.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatEventLoadAll extends ChatEvent {
  const ChatEventLoadAll();

  @override
  List<Object> get props => [];
}

class ChatEventRemove extends ChatEvent {
  final String chatId;

  const ChatEventRemove(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ChatEventSendMessage extends ChatEvent {
  final Message message;
  final Chat chat;

  const ChatEventSendMessage(this.message, this.chat);

  @override
  List<Object> get props => [message, chat];
}

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatStateLoading extends ChatState {
  const ChatStateLoading();

  @override
  List<Object> get props => [];
}

class ChatStateDone extends ChatState {
  final List<Chat> chats;

  const ChatStateDone(this.chats);

  @override
  List<Object> get props => [chats];
}
