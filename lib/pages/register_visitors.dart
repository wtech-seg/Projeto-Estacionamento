import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/theme/wtech_colors.dart';
import '../models/visitor.dart';
import '../providers/visitor_provider.dart';
import '../routes/app_routes.dart';

class RegisterVisitors extends StatefulWidget {
  const RegisterVisitors({super.key});

  @override
  State<RegisterVisitors> createState() => _RegisterVisitorsState();
}

class _RegisterVisitorsState extends State<RegisterVisitors> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> _registerVisitor() async {
    setState(() {
      isLoading = true;
    });

    // Cria o objeto Visitor com os dados preenchidos
    final visitor = Visitor(
      name: nameController.text,
      cpf: cpfController.text,
      phone: phoneController.text,
    );

    // Chama o metodo registerVisitor do VisitorProvider
    bool success = await Provider.of<VisitorProvider>(context, listen: false)
        .registerVisitor(context, visitor);

    setState(() {
      isLoading = false;
    });

    if (success) {
      // Se o cadastro for bem-sucedido, volta para a Home (ou mostra mensagem)
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar visitante')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cpfController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: WtechColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 21),
            child: Image.asset('assets/images/iconSemFundo.png', height: 23),
          ),
        ],
        title: const Text('Cadastro de Visitante'),
      ),
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
                SizedBox(height: size.height * 0.15),
                Text(
                  'Cadastrar visitante',
                  style: TextStyle(
                    color: WtechColors.textDarkGray,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Por favor, insira os dados do seu visitante para poder prosseguir',
                  style: TextStyle(
                    color: WtechColors.textCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: TextStyle(color: WtechColors.textDarkGray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                  ),
                  style: TextStyle(color: WtechColors.textDarkGray),
                ),
                SizedBox(height: size.height * 0.04),
                TextFormField(
                  controller: cpfController,
                  decoration: InputDecoration(
                    hintText: 'CPF',
                    hintStyle: TextStyle(color: WtechColors.textDarkGray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                  ),
                  style: TextStyle(color: WtechColors.textDarkGray),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: size.height * 0.04),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
                    hintStyle: TextStyle(color: WtechColors.textDarkGray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: const Color(0xFF122240)),
                    ),
                  ),
                  style: TextStyle(color: WtechColors.textDarkGray),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, bottom: 65, top: 10),
        child: isLoading
            ? const CircularProgressIndicator()
            : WtechMobileButton(
          label: 'Cadastrar',
          onPressed: _registerVisitor,
        ),
      ),
    );
  }
}
