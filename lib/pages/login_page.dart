// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/components/password_field.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart'; // Certifique-se de ter as rotas configuradas

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  late final LocalAuthentication auth;
  bool _suportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (bool isSupported) => setState(() {
        _suportState = isSupported;
      }),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.login(
      userController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Falha no login')));
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: WtechColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 23,
              right: 23,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.25),
                Text(
                  'Olá, bem vindo',
                  style: TextStyle(
                    color: WtechColors.textWhite,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Por favor, faça o login para\ncontinuar',
                  style: TextStyle(
                    color: WtechColors.textCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          hintText: 'Usuário',
                          hintStyle: TextStyle(color: WtechColors.textDarkGray),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF122240),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF122240),
                            ),
                          ),
                        ),
                        style: TextStyle(color: WtechColors.textDarkGray),
                      ),
                      const SizedBox(height: 34),
                      PasswordField(controller: passwordController),
                      const SizedBox(height: 86),
                      isLoading
                          ? const CircularProgressIndicator()
                          : WtechMobileButton(
                            label: 'Login',
                            onPressed: _login,
                          ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Ação para "Clique aqui" (ex: recuperação de senha)
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Problemas pra entrar?',
                              style: TextStyle(
                                color: WtechColors.textWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Clique aqui.',
                              style: TextStyle(
                                color: WtechColors.textCyan,
                                decoration: TextDecoration.underline,
                                decorationColor: WtechColors.textCyan,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
