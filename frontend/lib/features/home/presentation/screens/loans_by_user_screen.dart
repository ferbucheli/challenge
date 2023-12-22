import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/presentation/bloc/bloc.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:frontend/injection_container.dart';

class LoansByUserScreen extends StatelessWidget {
  const LoansByUserScreen({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans by user'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  sl<LoansBloc>()..add(GetLoansByUserEvent(userId: userId))),
          BlocProvider(
            create: (context) => sl<BooksBloc>(),
          )
        ],
        child: BlocBuilder<LoansBloc, LoansState>(
          builder: (context, state) {
            if (state is LoansLoading) {
              return Center(
                child: UiUtils.progress(
                    width: 150.rw(context), height: 150.rw(context)),
              );
            } else if (state is LoansLoaded) {
              return ListView.builder(
                itemCount: state.loans.length,
                itemBuilder: (context, index) {
                  return LoanWidget(loan: state.loans[index]);
                },
              );
            } else if (state is LoansError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}

class LoanWidget extends StatelessWidget {
  const LoanWidget({
    required this.loan,
    super.key,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        return ListTile(
          title: Text(loan.bookCode),
          subtitle: Text(loan.issueDate.toString()),
          trailing: loan.status == 'issued'
              ? CustomButton(
                  width: 50.rw(context),
                  onPressed: () {
                    context
                        .read<BooksBloc>()
                        .add(ReturnBookEvent(bookCode: loan.bookCode));
                  },
                  buttonTitle: 'Devolver libro',
                )
              : null,
        );
      },
    );
  }
}
