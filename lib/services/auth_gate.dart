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
    // Força a autenticação biométrica independentemente do token expirar ou não
    bool biometricsSuccess = await _biometricsAuth.authenticate();
    print("Resultado biométrico: $biometricsSuccess");
    if (biometricsSuccess) {
      // Atualize a expiração do token se necessário (aqui você pode definir um tempo mais longo)
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateTokenExpiry(extraSeconds: 7200);
    }
    setState(() {
      _isAuthenticated = biometricsSuccess;
    });
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
