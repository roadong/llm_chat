// lib/features/connection/screens/connection_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../providers/connection_provider.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController(); // ⬅️ 추가: API 키 컨트롤러
  bool _isApiKeyVisible = false; // ⬅️ 추가: API 키 가시성 상태

  @override
  void initState() {
    super.initState();
    final provider = context.read<ConnectionProvider>();
    provider.loadConnection().then((_) {
      if (mounted && provider.isConnected) {
        _urlController.text = provider.connectionModel?.baseUrl ?? '';
        _apiKeyController.text = provider.connectionModel?.apiKey ?? ''; // ⬅️ 추가
        // 이미 연결 정보가 있으면 바로 채팅 화면으로 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter.navigateToChat(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose(); // ⬅️ 추가
    super.dispose();
  }

  void _connect() async {
    final provider = context.read<ConnectionProvider>();
    final success = await provider.saveAndTestConnection(
      _urlController.text,
      _apiKeyController.text, // ⬅️ 추가: API 키 전달
    );
    if (mounted && success) {
      AppRouter.navigateToChat(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('연결 정보를 확인해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('백엔드 서버 연결')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ... 기존 서버 주소 입력창 ...
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Server Base URL',
                  hintText: 'https://api.openai.com/v1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // ⬇️⬇️⬇️ 추가된 API 키 입력 필드 ⬇️⬇️⬇️
              TextField(
                controller: _apiKeyController,
                obscureText: !_isApiKeyVisible, // 가시성 상태에 따라 텍스트 숨김
                decoration: InputDecoration(
                  labelText: 'API Key (Optional)',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isApiKeyVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isApiKeyVisible = !_isApiKeyVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ... 기존 연결 버튼 ...
              Consumer<ConnectionProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _connect,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text('저장 및 연결'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}