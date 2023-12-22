part of 'reservation_bloc.dart';

sealed class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object> get props => [];
}

final class ReservationInitial extends ReservationState {}

final class ReservationLoading extends ReservationState {}

final class ReservationConfirmed extends ReservationState {}

final class ReservationError extends ReservationState {
  final String message;

  ReservationError(this.message);

  @override
  List<Object> get props => [message];
}

final class ReservationDuplicate extends ReservationState {
  final String message;

  ReservationDuplicate(this.message);

  @override
  List<Object> get props => [message];
}

final class ReservationCancelled extends ReservationState {}

final class ReservationAlreadyConfirmed extends ReservationState {}
