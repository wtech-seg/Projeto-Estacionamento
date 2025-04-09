import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtech_design_system/design_system/design_system.dart';
import 'package:wtech_estacionamento/pages/home_page.dart';
import 'package:wtech_estacionamento/pages/register_visitors.dart';
import 'providers/auth_provider.dart';
import 'providers/user_input_provider.dart';
import 'providers/visitor_provider.dart';
import 'routes/app_routes.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserInputProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wtech App',
      theme: WtechTheme.defaultTheme,
      //home: HomePage(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
