import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/design_system.dart';

import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login); // Retorna à tela anterior (login)
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Bem-vinda ao app Wtech!',
          style: WtechTextStyles.headline,
        ),
      ),
    );
  }
}
