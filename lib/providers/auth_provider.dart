import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;

  // Outras informações do usuário, se necessário
  // Exemplo: String? _userName;

  String? get token => _token;

  bool get isAuthenticated => _token != null;

  /// Metodo de login: envia as credenciais para a API e armazena o token
  Future<bool> login(String email, String password) async {
    final url = Uri.parse(
      'https://suaapi.com/login',
    ); // Substitua pela URL da sua API

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token']; // Supondo que a resposta tenha um campo 'token'
        notifyListeners();
        return true;
      } else {
        // Trate erros conforme necessário
        return false;
      }
    } catch (e) {
      // Trate exceções
      return false;
    }
  }

  /// Metodo de logout: limpa o token e notifica os ouvintes
  void logout() {
    _token = null;
    notifyListeners();
  }
}
