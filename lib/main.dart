import 'package:flutter/material.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import 'package:wtech_estacionamento/pages/login_page.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wtech App',
      theme: WtechTheme.defaultTheme,
      // home: const LoginPage(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute, // ← inicia na splash
    );
  }
}
