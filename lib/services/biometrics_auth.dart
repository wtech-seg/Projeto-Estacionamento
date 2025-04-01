import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (!canCheckBiometrics) return false;

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Por favor, autentique-se para acessar o app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      print('Erro de autenticação biométrica: $e');
      return false;
    }
  }
}
