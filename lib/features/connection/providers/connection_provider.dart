import 'package:flutter/material.dart';
import '../data/models/connection_model.dart';
import '../data/repositories/connection_repository.dart';

class ConnectionProvider with ChangeNotifier {
  final ConnectionRepository _repository;
  ConnectionModel? _connectionModel;
  bool _isLoading = false;
  bool _isConnected = false;

  ConnectionProvider(this._repository) {
    loadConnection();
  }

  ConnectionModel? get connectionModel => _connectionModel;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  Future<void> loadConnection() async {
    _isLoading = true;
    notifyListeners();
    _connectionModel = await _repository.loadConnection();
    if (_connectionModel != null && _connectionModel!.baseUrl.isNotEmpty) {
      _isConnected = true; // 간단한 유효성 검사
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveAndTestConnection(String baseUrl, String? apiKey) async {
    _isLoading = true;
    notifyListeners();

    if (baseUrl.isNotEmpty && Uri.tryParse(baseUrl)?.hasAbsolutePath == true) {
      _connectionModel = ConnectionModel(
        baseUrl: baseUrl,
        apiKey: apiKey, // ⬅️ 추가
      );
      await _repository.saveConnection(_connectionModel!);
      _isConnected = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isConnected = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    await _repository.clearConnection();
    _connectionModel = null;
    _isConnected = false;
    notifyListeners();
  }
}