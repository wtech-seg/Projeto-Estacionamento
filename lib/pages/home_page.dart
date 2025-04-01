import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/components/body_card.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              'Visitantes',
              style: TextStyle(
                color: WtechColors.textDarkGray,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Por favor, selecione seu visitante\nou adicione um novo',
              style: TextStyle(
                color: WtechColors.textCyan,
                fontSize: 15,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: SingleChildScrollView(
              // clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    BodyCard(name: 'Ana Carolina Nesso Guedes'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 2'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 3'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 4'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 5'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 6'),
                    SizedBox(height: 10,),
                    BodyCard(name: 'Visitante 7'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, bottom: 65, top: 10),
        child: WtechMobileButton(
          label: 'Novo Visitante',
          onPressed: () {},
        ),
      ),
    );
  }
}
