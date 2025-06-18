import 'package:flutter/material.dart';
import '../../features/chat/data/screens/chat_screen.dart';
import '../../features/connection/screens/connection_screen.dart';

class AppRouter {
  static void navigateToChat(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
  }

  static void navigateToConnection(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ConnectionScreen()),
    );
  }
}