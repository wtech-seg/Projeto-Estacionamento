import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInputProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _cpfKey = 'cpf';

  String _cpf = '';
  String get cpf => _cpf;

  /// Retorna o CPF mascarado: os 3 primeiros dígitos permanecem e o resto é substituído por asteriscos
  String get maskedCpf {
    if (_cpf.length >= 11) {
      // Se o CPF tem pelo menos 11 dígitos (sem formatação)
      return '${_cpf.substring(0, 3)}.***.***-**';
    }
    return _cpf;
  }

  UserInputProvider() {
    _loadCpf();
  }

  Future<void> _loadCpf() async {
    final storedCpf = await _storage.read(key: _cpfKey);
    if (storedCpf != null) {
      _cpf = storedCpf;
      notifyListeners();
    }
  }

  Future<void> setCpf(String value) async {
    _cpf = value;
    await _storage.write(key: _cpfKey, value: value);
    notifyListeners();
  }
}
