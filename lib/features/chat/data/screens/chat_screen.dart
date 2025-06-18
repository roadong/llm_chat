import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_router.dart';
import '../../../connection/providers/connection_provider.dart';
import '../providers/chat_provider.dart';
import '../../widgets/chat_input_field.dart';
import '../../widgets/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final connectionProvider = context.read<ConnectionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '연결 끊기',
            onPressed: () {
              connectionProvider.disconnect();
              AppRouter.navigateToConnection(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, // 최신 메시지가 아래에 보이도록
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                // 역순으로 메시지에 접근
                final message =
                chatProvider.messages[chatProvider.messages.length - 1 - index];
                return MessageBubble(message: message);
              },
            ),
          ),
          if (chatProvider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(),
            ),
          const ChatInputField(),
        ],
      ),
    );
  }
}