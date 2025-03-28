import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/design_system.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Home'),
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
