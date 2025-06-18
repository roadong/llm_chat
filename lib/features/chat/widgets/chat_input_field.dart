import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/providers/chat_provider.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ChatProvider>().isLoading;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
