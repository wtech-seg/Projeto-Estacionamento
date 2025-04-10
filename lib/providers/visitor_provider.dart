import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/visitor.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class VisitorProvider with ChangeNotifier {
  List<Visitor> _visitors = [];
  List<Visitor> get visitors => _visitors;

  /// Metodo helper para obter os dados de autenticação do AuthProvider.
  /// Tenta obter token, enterpriseId e personId; caso enterpriseId ou personId estejam nulos,
  /// tenta decodificar o token para extrair esses valores.
  Map<String, String>? _getAuthData(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token?.trim();
    String? enterpriseId = authProvider.enterpriseId;
    String? personId = authProvider.responsibleId;

    // Se faltarem enterpriseId ou personId, tenta decodificar o token.
    if ((enterpriseId == null || personId == null) && token != null) {
      try {
        final decodedToken = JwtDecoder.decode(token);
        enterpriseId ??= decodedToken['enterpriseId']?.toString();
        personId ??= decodedToken['personId']?.toString();
      } catch (e) {
        print("Erro na decodificação do token: $e");
      }
    }

    if (token == null || enterpriseId == null || personId == null) {
      print("Dados de autenticação insuficientes: token: $token, enterpriseId: $enterpriseId, personId: $personId");
      return null;
    }

    return {
      'token': token,
      'enterpriseId': enterpriseId,
      'personId': personId,
    };
  }

  /// Busca os visitantes na API utilizando o CPF fornecido.
  Future<void> fetchVisitors(BuildContext context, String cpf) async {
    final authData = _getAuthData(context);
    if (authData == null) {
      print("Não foi possível obter os dados de autenticação para buscar visitantes.");
      return;
    }

    // Monta a URL usando os dados de autenticação e o CPF
    final url = Uri.parse(
        'http://77.37.69.47:8060/wtech/client/persons/visitors/${authData['enterpriseId']}/${authData['personId']}'
    );
    print("URL (fetchVisitors): $url");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Usa o token com o prefixo Bearer (ajuste se necessário)
          'Authorization': '${authData['token']}',
        },
      );
      print("Response status (fetchVisitors): ${response.statusCode}");
      print("Response body (fetchVisitors): ${response.body}");

      if (response.statusCode == 200) {
        // Supondo que o response.body seja um JSON contendo uma chave "visitors"
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> data = decodedData['visitors'] ?? [];
        _visitors = data.map((json) => Visitor.fromJson(json)).toList();
        print("Visitantes obtidos: ${_visitors.length}");
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar visitantes: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no fetchVisitors: $e');
    }
  }

  /// A URL para cadastro é:
  /// http://77.37.69.47:8060/wtech/client/persons/visitors/enterpriseID/personID
  Future<bool> registerVisitor(BuildContext context, Visitor visitor) async {
    final authData = _getAuthData(context);
    if (authData == null) {
      print("Dados de autenticação insuficientes para registrar visitante");
      return false;
    }

    // Monta a URL de cadastro
    final url = Uri.parse(
        'http://77.37.69.47:8060/wtech/client/persons/visitors/${authData['enterpriseId']}/${authData['personId']}'
    );
    print("URL (registerVisitor): $url");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '${authData['token']}',
        },
        body: jsonEncode(visitor.toJson()),
      );
      print("Register Response status: ${response.statusCode}");
      print("Register Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Erro ao cadastrar visitante: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro no registerVisitor: $e");
      return false;
    }
  }
}
