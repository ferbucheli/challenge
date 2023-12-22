import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

import '../../../../core/error/error.dart';
import '../../../../core/usecases/usecase.dart';

class LoanUseCase extends UseCase<void, LoanParams> {
  final HomeRepository repository;

  LoanUseCase(this.repository);

  @override
  Future<Either<Failure, void>?> call(LoanParams params) async {
    return await repository.confirmReservation(params.bookCode);
  }
}

class LoanParams extends Equatable {
  final String bookCode;

  LoanParams(this.bookCode);

  @override
  List<Object> get props => [bookCode];
}
