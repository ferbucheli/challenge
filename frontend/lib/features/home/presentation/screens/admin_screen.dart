import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onPressed: () => context.go('/admin/books'),
          buttonTitle: 'Administrar libros',
        ),
        CustomButton(
          onPressed: () => context.go('/admin/loans'),
          buttonTitle: 'Administrar préstamos',
        ),
      ],
    );
  }
}
