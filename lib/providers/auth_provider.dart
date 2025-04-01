import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _lastAuthTimeKey = 'last_auth_time';

  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _secureStorage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<bool> login(String cpf, String password) async {
    final url = Uri.parse('http://77.37.69.47:8060/wtech/client/persons/login/1'); // Substitua pela URL da sua API
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cpf': cpf, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        // Armazene o token e o timestamp atual
        await _secureStorage.write(key: _tokenKey, value: _token);
        await _secureStorage.write(
          key: _lastAuthTimeKey,
          value: DateTime.now().toIso8601String(),
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _lastAuthTimeKey);
    notifyListeners();
  }

  /// Checa se o tempo de inatividade ultrapassou o limite (ex.: 2 horas)
  Future<bool> isSessionExpired(Duration timeout) async {
    String? lastAuthTimeStr = await _secureStorage.read(key: _lastAuthTimeKey);
    if (lastAuthTimeStr == null) return true;
    DateTime lastAuthTime = DateTime.parse(lastAuthTimeStr);
    return DateTime.now().difference(lastAuthTime) > timeout;
  }

  /// Atualiza o timestamp da última autenticação
  Future<void> updateLastAuthTime() async {
    await _secureStorage.write(
      key: _lastAuthTimeKey,
      value: DateTime.now().toIso8601String(),
    );
  }
}
