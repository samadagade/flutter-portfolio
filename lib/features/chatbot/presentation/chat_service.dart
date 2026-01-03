import 'dart:async';
import 'dart:math';

import 'package:portfolio/features/chatbot/domain/entity/message.dart';
import 'package:portfolio/features/chatbot/presentation/chat_bot.dart';

class ChatService {
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  final StreamController<bool> _typingController =
      StreamController<bool>.broadcast();
  // ignore: unused_field
  final Random _random = Random();

  Stream<Message> get messageStream => _messageController.stream;
  Stream<bool> get typingStream => _typingController.stream;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = Message(text: text, isMe: true, timestamp: DateTime.now());

    _messageController.add(message);
    _typingController.add(true);

    handleUserMessage(text, _messageController, _typingController);
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
  }
}