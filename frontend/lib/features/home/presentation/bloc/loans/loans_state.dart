part of 'loans_bloc.dart';

sealed class LoansState extends Equatable {
  const LoansState();

  @override
  List<Object> get props => [];
}

final class LoansInitial extends LoansState {}

final class LoansLoading extends LoansState {}

final class LoansLoaded extends LoansState {
  final List<Loan> loans;

  LoansLoaded({
    required this.loans,
  });

  @override
  List<Object> get props => [loans];
}

final class LoansError extends LoansState {
  final String message;

  LoansError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
