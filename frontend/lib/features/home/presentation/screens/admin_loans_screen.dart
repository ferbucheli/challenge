import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/utils/ui_utils.dart';
import 'package:frontend/injection_container.dart';
import 'package:go_router/go_router.dart';

class AdminLoansScreen extends StatelessWidget {
  const AdminLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
        title: const Text('Administrar préstamos'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoansBloc>()..add(GetAllLoansEvent()),
      child: BlocBuilder<LoansBloc, LoansState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: 20.rh(context)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Administrador de biblioteca',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              SizedBox(height: 20.rh(context)),
              if (state is LoansLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.loans.length,
                    itemBuilder: (context, index) {
                      final loan = state.loans[index];
                      return ListTile(
                        title: Text(
                          loan.bookCode,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text('Student with id: ${loan.studentId}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      );
                    },
                  ),
                ),
              if (state is LoansLoading)
                Expanded(
                  child: Center(
                    child: UiUtils.progress(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
