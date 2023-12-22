import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/usecases/get_loans_by_user.dart';
import 'package:frontend/features/home/domain/usecases/usecases.dart';

import '../../../../../core/error/error.dart';

part 'loans_event.dart';
part 'loans_state.dart';

class LoansBloc extends Bloc<LoansEvent, LoansState> {
  String SERVER_FAILURE_MESSAGE = 'Server Failure';
  String CACHE_FAILURE_MESSAGE = 'Cache Failure';

  final GetLoansByUser getLoansByUser;
  final GetLoans getLoans;

  LoansBloc({
    required this.getLoansByUser,
    required this.getLoans,
  }) : super(LoansInitial()) {
    on<GetLoansByUserEvent>(_onGetLoansByUserEvent);
    on<GetAllLoansEvent>(_onGetAllLoansEvent);
  }

  Future<void> _onGetLoansByUserEvent(
    GetLoansByUserEvent event,
    Emitter<LoansState> emit,
  ) async {
    emit(LoansLoading());

    final failureOrLoans =
        await getLoansByUser(GetLoansByUserParams(userId: event.userId));
    failureOrLoans!.fold(
      (failure) => emit(LoansError(message: _mapFailureToMessage(failure))),
      (loans) => emit(LoansLoaded(loans: loans)),
    );
  }

  Future<void> _onGetAllLoansEvent(
    GetAllLoansEvent event,
    Emitter<LoansState> emit,
  ) async {
    emit(LoansLoading());

    final failureOrLoans = await getLoans(NoParams());
    failureOrLoans!.fold(
      (failure) => emit(LoansError(message: _mapFailureToMessage(failure))),
      (loans) => emit(LoansLoaded(loans: loans)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
