import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ChatMessage {
  final String id;
  String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
  })  : id = uuid.v4(),
        timestamp = DateTime.now();
}