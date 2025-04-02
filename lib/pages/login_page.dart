import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/components/password_field.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import '../providers/auth_provider.dart';
import '../providers/user_input_provider.dart';
import '../routes/app_routes.dart';
import '../services/cpf_mask_format.dart'; // Contém o cpfMaskFormatter
import '../services/biometrics_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode cpfFocusNode = FocusNode();

  bool isLoading = false;
  late final LocalAuthentication auth;
  bool _supportState = false;

  // Controla se a autenticação biométrica já foi solicitada nesta tela.
  bool _biometricPromptShown = false;
  final BiometricsAuth _biometricsAuth = BiometricsAuth();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
      },
    );

    // Se já existir um CPF salvo, exibe a versão mascarada.
    final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
    if (userInputProvider.cpf.isNotEmpty) {
      cpfController.text = userInputProvider.maskedCpf;
      // Chama o prompt biométrico apenas uma vez
      if (!_biometricPromptShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _promptBiometrics();
        });
      }
    }

    // Listener para tratar o foco no campo CPF:
    cpfFocusNode.addListener(() {
      final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
      if (cpfFocusNode.hasFocus) {
        // Exibe o CPF completo para edição
        cpfController.text = userInputProvider.cpf;
        cpfController.selection = TextSelection.fromPosition(
          TextPosition(offset: cpfController.text.length),
        );
      } else {
        // Quando perde o foco, salva o CPF "cru" (apenas dígitos) e exibe a versão mascarada
        final rawCpf = cpfController.text.replaceAll(RegExp(r'\D'), '');
        userInputProvider.setCpf(rawCpf);
        cpfController.text = userInputProvider.maskedCpf;
      }
    });
  }

  Future<bool> _checkBiometrics() async {
    bool biometricsSuccess = await _biometricsAuth.authenticate();
    print("Resultado biométrico: $biometricsSuccess");
    return biometricsSuccess;
  }

  Future<void> _promptBiometrics() async {
    _biometricPromptShown = true;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // O usuário precisa escolher uma opção
      builder: (context) => AlertDialog(
        title: const Text('Autenticação biométrica'),
        content: const Text('Deseja usar sua digital para acessar o app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );
    if (result == true) {
      bool success = await _checkBiometrics();
      if (success) {
        // Se a digital for aprovada, mostra o CPF completo para facilitar a edição.
        final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
        cpfController.text = userInputProvider.cpf;
      }
    }
    // Se o usuário optar por "Não" ou se a digital falhar, ele poderá digitar manualmente.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cpfController.dispose();
    passwordController.dispose();
    cpfFocusNode.dispose();
    super.dispose();
  }

  // Detecta quando o app retorna ao primeiro plano
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
      if (userInputProvider.cpf.isNotEmpty) {
        _promptBiometrics();
      }
    }
  }

  Widget _buildHeader(Size size) {
    return Column(
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
      ],
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: cpfController,
            focusNode: cpfFocusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [cpfFormatter],
            decoration: InputDecoration(
              hintText: 'CPF',
              hintStyle: TextStyle(color: WtechColors.textDarkGray),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF122240)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF122240)),
              ),
            ),
            style: TextStyle(color: WtechColors.textWhite),
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
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      print('Entrou na função de login');
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
    bool success = await authProvider.login(
      userInputProvider.cpf, // Envia o CPF "cru" (apenas dígitos)
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Falha no login')));
    }
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
                _buildHeader(size),
                const SizedBox(height: 60),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
