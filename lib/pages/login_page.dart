import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/design_system.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WtechColors.primary,
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 23, right: 23),
          child: Column(
            children: [
              SizedBox(height: 232),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Olá, bem vindo',
                  style: TextStyle(
                    color: WtechColors.textWhite,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Por favor, faça o login para continuar',
                  style: TextStyle(
                    color: WtechColors.textCyan,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              TextFormField(decoration: InputDecoration(hintText: 'Usuário')),
              TextFormField(decoration: InputDecoration(hintText: 'Senha')),
              SizedBox(height: 86),
              WtechMobileButton(label: 'Login', onPressed: () {}),
              SizedBox(height: 28),
              Row(
                children: [
                  Text(
                    'Problemas pra entrar?',
                    style: TextStyle(
                      color: WtechColors.textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    'Clique aqui.',
                    style: TextStyle(
                      color: WtechColors.textCyan,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
