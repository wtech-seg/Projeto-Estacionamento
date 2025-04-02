import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/components/password_field.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import '../providers/auth_provider.dart';
import '../providers/user_input_provider.dart';
import '../routes/app_routes.dart';
import '../services/cpf_mask_format.dart'; // Supondo que aqui esteja o cpfMaskFormatter

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode cpfFocusNode = FocusNode();

  bool isLoading = false;
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
        _supportState = isSupported;
      }),
    );

    // Carrega o CPF salvo (valor sem formatação) do provider e exibe a versão mascarada
    final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
    if (userInputProvider.cpf.isNotEmpty) {
      cpfController.text = userInputProvider.maskedCpf;
    }

    // Adiciona listener para tratar o foco do campo CPF
    cpfFocusNode.addListener(() {
      final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
      if (cpfFocusNode.hasFocus) {
        // Quando ganha foco, exibe o CPF completo (sem formatação) para edição
        cpfController.text = userInputProvider.cpf;
        cpfController.selection = TextSelection.fromPosition(
          TextPosition(offset: cpfController.text.length),
        );
      } else {
        // Quando perde o foco, extrai o valor "cru" (apenas dígitos) e salva no provider
        final rawCpf = cpfController.text.replaceAll(RegExp(r'\D'), '');
        userInputProvider.setCpf(rawCpf);
        // Atualiza o campo com a versão mascarada para visualização
        cpfController.text = userInputProvider.maskedCpf;
      }
    });
  }

  @override
  void dispose() {
    cpfController.dispose();
    passwordController.dispose();
    cpfFocusNode.dispose();
    super.dispose();
  }

  /// Constrói o cabeçalho da tela de login
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

  /// Constrói o formulário de login
  Widget _buildLoginForm() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de CPF com máscara de entrada
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

  /// Função que realiza o login; utiliza o CPF "cru" (do provider) para a requisição
  Future<void> _login() async {
    setState(() {
      isLoading = true;
      print('Entrou na função de login');
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userInputProvider = Provider.of<UserInputProvider>(context, listen: false);
    bool success = await authProvider.login(
      userInputProvider.cpf, // CPF sem formatação (apenas dígitos)
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
