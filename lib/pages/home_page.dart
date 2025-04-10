import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import '../providers/user_input_provider.dart';
import '../providers/visitor_provider.dart';
import '../routes/app_routes.dart';
import 'package:wtech_design_system/design_system/components/body_card.dart';
import 'package:wtech_design_system/design_system/components/wtech_mobile_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Supondo que você já tenha o CPF do usuário no Provider, ou pode passar via parâmetro.
  @override
  void initState() {
    super.initState();
    final cpf = Provider.of<UserInputProvider>(context, listen: false).cpf;
    // Chama o fetchVisitors() no initState; você pode passar o CPF do usuário se necessário.
    Future.microtask(() {
      Provider.of<VisitorProvider>(
        context,
        listen: false,
      ).fetchVisitors(context, cpf); // Exemplo: substitua pelo CPF "cru"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Consumer<VisitorProvider>(
                builder: (context, visitorProvider, child) {
                  if (visitorProvider.visitors.isEmpty) {
                    return const Center(
                      child: Text('Nenhum visitante cadastrado'),
                    );
                  }
                  return ListView.separated(
                    itemCount: visitorProvider.visitors.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final visitor = visitorProvider.visitors[index];
                      return BodyCard(name: visitor.name);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 28,
          right: 28,
          bottom: 65,
          top: 28,
        ),
        child: WtechMobileButton(
          label: 'Novo Visitante',
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.register);
          },
        ),
      ),
    );
  }
}
