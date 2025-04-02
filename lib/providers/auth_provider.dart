import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';

  String? _token;
  DateTime? _tokenExpiry;

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadTokenData();
  }

  Future<void> _loadTokenData() async {
    _token = await _secureStorage.read(key: _tokenKey);
    String? expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr != null) {
      _tokenExpiry = DateTime.tryParse(expiryStr);
    }
    notifyListeners();
  }

  /// Realiza o login e armazena o token e a data de expiração.
  /// Supomos que o JSON de resposta tenha:
  /// { "token": "...", "expires_in": 3600 }  (expires_in em segundos)
  Future<bool> login(String cpf, String password) async {
    final url = Uri.parse('http://77.37.69.47:8060/wtech/client/login/1'); // Altere para a URL da sua API
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cpf': cpf, 'password': password}),
      );

      print(cpf);
      print(password);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];


        // Supondo que o backend envie "expires_in" em segundos
        int expiresIn = data['expires_in'] ?? 10; // valor padrão de 1 hora
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
        print(expiresIn);

        // Armazena token e expiração de forma segura
        await _secureStorage.write(key: _tokenKey, value: _token);
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: _tokenExpiry!.toIso8601String(),
        );

        notifyListeners();
        return true;
      } else {
        print('Erro no login ??');
        return false;
      }
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _tokenExpiry = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
    notifyListeners();
  }

  /// Verifica se a sessão expirou comparando a data atual com o token de expiração.
  Future<bool> isSessionExpired() async {
    String? expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return true;
    DateTime expiry = DateTime.parse(expiryStr);
    return DateTime.now().isAfter(expiry);
  }

  /// Atualiza o timestamp de expiração (se, por exemplo, a autenticação biométrica for bem-sucedida).
  Future<void> updateTokenExpiry({required int extraSeconds}) async {
    // Você pode definir um novo período de validade, por exemplo, renovar a sessão.
    _tokenExpiry = DateTime.now().add(Duration(seconds: extraSeconds));
    await _secureStorage.write(key: _tokenExpiryKey, value: _tokenExpiry!.toIso8601String());
    notifyListeners();
  }
}
