import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

import '../../../../core/error/error.dart';
import '../../../../core/usecases/usecase.dart';

class CancelReservation extends UseCase<void, CancelReservationParams> {
  final HomeRepository repository;

  CancelReservation(this.repository);

  @override
  Future<Either<Failure, void>?> call(CancelReservationParams params) async {
    return await repository.cancelReservation(params.bookCode);
  }
}

class CancelReservationParams extends Equatable {
  final String bookCode;

  CancelReservationParams(this.bookCode);

  @override
  List<Object> get props => [bookCode];
}
