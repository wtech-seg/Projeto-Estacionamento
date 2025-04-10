import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/theme/wtech_colors.dart';

import '../routes/app_routes.dart';

class RegisterVisitors extends StatefulWidget {
  const RegisterVisitors({super.key});

  @override
  State<RegisterVisitors> createState() => _RegisterVisitorsState();
}

class _RegisterVisitorsState extends State<RegisterVisitors> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: WtechColors.background,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 21),
            child: Image.asset('assets/images/iconSemFundo.png', height: 23),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
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
                  'Por favor, insira os dados do seu visitante\npara poder prosseguir',
                  style: TextStyle(
                    color: WtechColors.textCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    hintStyle: TextStyle(color: WtechColors.textDarkGray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF122240)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF122240)),
                    ),
                  ),
                  style: TextStyle(color: WtechColors.textDarkGray),
                ),
                SizedBox(height: size.height * 0.04),
                TextFormField(
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
                  style: TextStyle(color: WtechColors.textDarkGray),
                ),
                SizedBox(height: size.height * 0.04),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Telefone',
                    hintStyle: TextStyle(color: WtechColors.textDarkGray),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF122240)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF122240)),
                    ),
                  ),
                  style: TextStyle(color: WtechColors.textDarkGray),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 28,
          right: 28,
          bottom: 65,
          top: 10,
        ),
        child: WtechMobileButton(
          label: 'Gerar',
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.register);
          },
        ),
      ),
    );
  }
}
