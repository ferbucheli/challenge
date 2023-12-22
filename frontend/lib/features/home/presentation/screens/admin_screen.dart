import 'package:flutter/material.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logo_espol.png',
          height: 40,
        ),
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
