import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constant.dart';
import '../models/connection_model.dart';

class ConnectionRepository {
  Future<void> saveConnection(ConnectionModel connection) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(connection.toJson());
    await prefs.setString(AppConstants.connectionInfoKey, jsonString);
  }

  Future<ConnectionModel?> loadConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(AppConstants.connectionInfoKey);
    if (jsonString != null) {
      return ConnectionModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<void> clearConnection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.connectionInfoKey);
  }
}