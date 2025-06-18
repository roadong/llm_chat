import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/chat/data/services/chat_service.dart';
import 'features/chat/data/providers/chat_provider.dart';
import 'features/connection/data/repositories/connection_repository.dart';
import 'features/connection/providers/connection_provider.dart';
import 'features/connection/screens/connection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 여러 Provider를 앱 전역에 제공
    return MultiProvider(
      providers: [
        // 독립적인 Provider
        ChangeNotifierProvider(
          create: (_) => ConnectionProvider(ConnectionRepository()),
        ),
        Provider(create: (_) => ChatService()),

        // 다른 Provider에 의존하는 Provider (ProxyProvider 사용)
        ChangeNotifierProxyProvider<ConnectionProvider, ChatProvider>(
          create: (context) => ChatProvider(
            connectionProvider: context.read<ConnectionProvider>(),
            chatService: context.read<ChatService>(),
          ),
          update: (context, connectionProvider, previousChatProvider) =>
              ChatProvider(
                connectionProvider: connectionProvider,
                chatService: context.read<ChatService>(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Custom AI Chat',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const ConnectionScreen(), // 시작은 연결 화면부터
      ),
    );
  }
}