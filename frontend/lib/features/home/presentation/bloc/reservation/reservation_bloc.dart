import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/features/home/domain/usecases/usecases.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  String SERVER_FAILURE_MESSAGE = 'Server Failure';
  String CACHE_FAILURE_MESSAGE = 'Cache Failure';

  final ReserveBook reserveBook;
  final CancelReservation cancelReservation;
  final LoanUseCase loan;

  ReservationBloc({
    required this.reserveBook,
    required this.cancelReservation,
    required this.loan,
  }) : super(ReservationInitial()) {
    on<ReserveBookEvent>(_onReserveBookRequested);
    on<CancelReservationEvent>(_onCancelReservationRequested);
    on<ConfirmReservationEvent>(_onConfirmReservationRequested);
  }

  Future<void> _onReserveBookRequested(
      ReserveBookEvent event, Emitter<ReservationState> emit) async {
    emit(ReservationLoading());
    final failureOrBook = await reserveBook(ReserveBookParams(event.bookCode));
    failureOrBook!.fold(
      (failure) => emit(ReservationDuplicate(_mapFailureToMessage(failure))),
      (book) => emit(ReservationConfirmed()),
    );
  }

  Future<void> _onCancelReservationRequested(
      CancelReservationEvent event, Emitter<ReservationState> emit) async {
    emit(ReservationLoading());
    final failureOrBook =
        await cancelReservation(CancelReservationParams(event.bookCode));
    failureOrBook!.fold(
      (failure) => emit(ReservationError(_mapFailureToMessage(failure))),
      (book) => emit(ReservationCancelled()),
    );
  }

  Future<void> _onConfirmReservationRequested(
      ConfirmReservationEvent event, Emitter<ReservationState> emit) async {
    emit(ReservationLoading());
    final failureOrBook = await loan(LoanParams(event.bookCode));
    failureOrBook!.fold(
      (failure) => emit(ReservationError(_mapFailureToMessage(failure))),
      (book) => emit(ReservationAlreadyConfirmed()),
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
