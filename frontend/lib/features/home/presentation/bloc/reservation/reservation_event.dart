part of 'reservation_bloc.dart';

sealed class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object> get props => [];
}

class ReserveBookEvent extends ReservationEvent {
  final String bookCode;

  ReserveBookEvent(this.bookCode);
}

class CancelReservationEvent extends ReservationEvent {
  final String bookCode;

  CancelReservationEvent(this.bookCode);
}

class ConfirmReservationEvent extends ReservationEvent {
  final String bookCode;

  ConfirmReservationEvent(this.bookCode);
}
