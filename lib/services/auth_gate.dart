import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/biometrics_auth.dart';

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
    bool expired = await authProvider.isSessionExpired();

    if (expired) {
      // Se a sessão expirou, solicitar autenticação biométrica
      bool biometricsSuccess = await _biometricsAuth.authenticate();
      if (biometricsSuccess) {
        // Após autenticar com biometria, atualize a expiração do token.
        // Você pode decidir qual novo período definir. Exemplo: mais 2 horas (7200 segundos)
        await authProvider.updateTokenExpiry(extraSeconds: 1);
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
