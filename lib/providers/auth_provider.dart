import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _enterpriseIdKey = 'enterprise_id';
  static const String _responsibleIdKey = 'responsible_id';

  String? _token;
  DateTime? _tokenExpiry;
  String? _enterpriseId;
  String? _responsibleId;

  String? get token => _token;
  DateTime? get tokenExpiry => _tokenExpiry;
  String? get enterpriseId => _enterpriseId;
  String? get responsibleId => _responsibleId;
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
    _enterpriseId = await _secureStorage.read(key: _enterpriseIdKey);
    _responsibleId = await _secureStorage.read(key: _responsibleIdKey);
    notifyListeners();
  }

  /// Realiza o login e armazena o token, a data de expiração e os dados do usuário
  /// Espera que o JSON de resposta contenha:
  /// { "token": "...", "expires_in": 3600, "enterpriseId": "...", "responsibleId": "..." }
  Future<bool> login(String cpf, String password) async {
    final url = Uri.parse('http://77.37.69.47:8060/wtech/client/persons/login/1');
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
        print('Token recebido: $_token');

        // Armazena os dados do usuário retornados pela API
        _enterpriseId = data['enterpriseId']?.toString();
        _responsibleId = data['responsibleId']?.toString();

        // Supondo que o backend envie "expires_in" em segundos
        int expiresIn = data['expires_in'] ?? 10;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
        print('Token expira em $expiresIn segundos');

        // Armazena token, expiração e demais dados de forma segura
        await _secureStorage.write(key: _tokenKey, value: _token);
        await _secureStorage.write(key: _tokenExpiryKey, value: _tokenExpiry!.toIso8601String());
        if (_enterpriseId != null) {
          await _secureStorage.write(key: _enterpriseIdKey, value: _enterpriseId);
        }
        if (_responsibleId != null) {
          await _secureStorage.write(key: _responsibleIdKey, value: _responsibleId);
        }

        notifyListeners();
        return true;
      } else {
        print('Erro no login: status code ${response.statusCode}');
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
    _enterpriseId = null;
    _responsibleId = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
    await _secureStorage.delete(key: _enterpriseIdKey);
    await _secureStorage.delete(key: _responsibleIdKey);
    notifyListeners();
  }

  /// Verifica se a sessão expirou comparando a data atual com o token de expiração.
  Future<bool> isSessionExpired() async {
    String? expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return true;
    DateTime expiry = DateTime.parse(expiryStr);
    return DateTime.now().isAfter(expiry);
  }

  /// Atualiza o timestamp de expiração (por exemplo, após autenticação biométrica)
  Future<void> updateTokenExpiry({required int extraSeconds}) async {
    _tokenExpiry = DateTime.now().add(Duration(seconds: extraSeconds));
    await _secureStorage.write(key: _tokenExpiryKey, value: _tokenExpiry!.toIso8601String());
    notifyListeners();
  }
}
