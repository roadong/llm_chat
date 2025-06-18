import 'dart:async';
import 'package:flutter/material.dart';
import '../../../connection/providers/connection_provider.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ConnectionProvider connectionProvider;
  final ChatService chatService;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  StreamSubscription? _chatSubscription;

  ChatProvider({required this.connectionProvider, required this.chatService});

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    // 이전 스트림이 있다면 취소
    await _chatSubscription?.cancel();

    final baseUrl = connectionProvider.connectionModel?.baseUrl;
    final apiKey = connectionProvider.connectionModel?.apiKey;
    if (baseUrl == null) {
      // 베이스 URL이 없는 경우 에러 처리
      _messages.add(ChatMessage(
          text: '연결 정보가 없습니다. 연결 설정 화면으로 돌아가주세요.', isUser: false));
      notifyListeners();
      return;
    }

    _messages.add(ChatMessage(text: text, isUser: true));
    _messages.add(ChatMessage(text: '', isUser: false)); // AI 응답 placeholder
    _isLoading = true;
    notifyListeners();

    final openAiMessages = _messages
        .where((msg) => msg.text.isNotEmpty) // AI의 빈 응답 placeholder는 제외
        .map((msg) => {
      'role': msg.isUser ? 'user' : 'assistant',
      'content': msg.text,
    })
        .toList();
    // 마지막 빈 AI 메시지는 history에서 제거
    // openAiMessages.removeLast();

    final stream = chatService.sendMessageStream(messages: openAiMessages, baseUrl: baseUrl, apiKey: apiKey);

    _chatSubscription = stream.listen(
          (token) {
        _messages.last.text += token;
        notifyListeners();
      },
      onDone: () {
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _messages.last.text = '오류가 발생했습니다: $e';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}