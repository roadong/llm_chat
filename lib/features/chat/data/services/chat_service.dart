// lib/features/chat/data/services/chat_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

class ChatService {
  Stream<String> sendMessageStream({
    required List<Map<String, String>> messages,
    required String baseUrl,
    String? apiKey,
  }) {
    // 1. 스트림을 직접 제어하기 위해 StreamController를 생성합니다.
    final controller = StreamController<String>();
    // SSE 구독 객체를 저장할 변수
    StreamSubscription? sseSubscription;

    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "text/event-stream",
    };
    if (apiKey != null && apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    final body = {
      'model': 'anthropic.claude-3-5-sonnet-20240620-v1:0',
      'messages': messages,
      'stream': true,
      'max_tokens': 2048,
    };

    final url = '$baseUrl/chat/completions';

    // 2. 실제 SSE 구독을 시작하고, 구독 객체를 변수에 저장합니다.
    sseSubscription = SSEClient.subscribeToSSE(
      method: SSERequestType.POST,
      url: url,
      header: headers,
      body: body,
    ).listen(
          (event) {
        if (event.data != null && event.data!.isNotEmpty) {
          // 3. [DONE] 신호를 감지하면, 직접 스트림을 닫고 종료합니다.
          if (event.data!.contains('[DONE]')) {
            controller.close(); // 컨트롤러를 닫아 ChatProvider에 종료 신호를 보냄
            sseSubscription?.cancel(); // 불필요한 리소스 정리를 위해 구독 취소
            return;
          }

          try {
            final decodedData = jsonDecode(event.data!);
            final content = decodedData['choices']?[0]?['delta']?['content'] as String?;

            if (content != null) {
              // 4. 정상적인 데이터는 컨트롤러에 추가합니다.
              controller.add(content);
            }
          } catch (e) {
            // 파싱 오류 발생 시 컨트롤러에 에러를 전달할 수 있습니다.
            controller.addError(e);
          }
        }
      },
      onError: (error) {
        // SSE 연결 자체에 에러 발생 시
        controller.addError(error);
        controller.close();
      },
      onDone: () {
        // 서버가 연결을 정상적으로 닫아주는 경우 (안전장치)
        controller.close();
      },
    );

    // ChatProvider에서 스트림 구독을 취소할 때, SSE 구독도 함께 취소되도록 설정
    controller.onCancel = () {
      sseSubscription?.cancel();
    };

    // 5. ChatProvider에는 우리가 제어하는 컨트롤러의 스트림을 반환합니다.
    return controller.stream;
  }
}