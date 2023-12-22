part of 'loans_bloc.dart';

sealed class LoansEvent extends Equatable {
  const LoansEvent();

  @override
  List<Object> get props => [];
}

class GetLoansByUserEvent extends LoansEvent {
  final String userId;

  GetLoansByUserEvent({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}
