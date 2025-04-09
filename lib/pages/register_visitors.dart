import 'package:flutter/material.dart';
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
