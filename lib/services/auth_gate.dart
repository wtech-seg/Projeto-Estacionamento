import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtech_estacionamento/services/biometrics_auth.dart';
import '../providers/auth_provider.dart';

class AuthGate extends StatefulWidget {
  final Widget child;
  const AuthGate({Key? key, required this.child}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isAuthenticated = false;
  final BiometricsAuth _biometricsAuth = BiometricsAuth();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Define o timeout, por exemplo, 2 horas
    final Duration timeout = const Duration(seconds: 10);
    bool expired = await authProvider.isSessionExpired(timeout);

    if (expired) {
      // Se a sessão expirou, solicitar biometria
      bool biometricsSuccess = await _biometricsAuth.authenticate();
      if (biometricsSuccess) {
        // Se autenticado com biometria, atualiza o timestamp
        await authProvider.updateLastAuthTime();
      }
      setState(() {
        _isAuthenticated = biometricsSuccess;
      });
    } else {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? widget.child
        : const Scaffold(
      body: Center(child: Text('Autenticação necessária')),
    );
  }
}
