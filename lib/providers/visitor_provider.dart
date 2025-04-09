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

  /// Busca os visitantes na API utilizando o CPF.
  Future<void> fetchVisitors(BuildContext context, String cpf) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? enterpriseId = authProvider.enterpriseId;
    String? responsibleId = authProvider.responsibleId;

    // Se ainda estiverem nulos, tenta decodificar o token para extrair os dados.
    if (enterpriseId == null || responsibleId == null) {
      final token = authProvider.token;
      if (token != null) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        enterpriseId = decodedToken['enterpriseId']?.toString();
        responsibleId = decodedToken['personId']?.toString();
        print('Decoded enterpriseId: $enterpriseId');
        print('Decoded responsibleId (personId): $responsibleId');
      }
    }

    if (enterpriseId == null || responsibleId == null) {
      print("enterpriseId ou responsibleId estão nulos");
      return;
    }

    // Monta a URL com os dados extraídos e o CPF (apenas dígitos)
    final url = Uri.parse(
        'http://77.37.69.47:8060/wtech/client/persons/visitors/$enterpriseId/$responsibleId');
    print("URL: $url");

    try {
      // Obtém o token para os headers
      final token = authProvider.token;
      if (token == null) {
        print("Token não encontrado no AuthProvider.");
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Como a resposta já é um JSON padrão, use jsonDecode diretamente.
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
}