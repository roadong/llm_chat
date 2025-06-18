// lib/features/connection/data/models/connection_model.dart

class ConnectionModel {
  final String baseUrl;
  final String? apiKey; // ⬅️ 추가: API 키 필드

  ConnectionModel({required this.baseUrl, this.apiKey});

  Map<String, dynamic> toJson() => {
    'baseUrl': baseUrl,
    'apiKey': apiKey, // ⬅️ 추가
  };

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      baseUrl: json['baseUrl'],
      apiKey: json['apiKey'], // ⬅️ 추가
    );
  }
}