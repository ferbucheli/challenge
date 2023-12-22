import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

class ReserveBook extends UseCase<void, ReserveBookParams> {
  final HomeRepository repository;

  ReserveBook(this.repository);

  @override
  Future<Either<Failure, void>?> call(ReserveBookParams params) async {
    return await repository.reserveBook(params.bookCode);
  }
}

class ReserveBookParams extends Equatable {
  final String bookCode;

  const ReserveBookParams(this.bookCode);

  @override
  List<Object?> get props => [bookCode];
}
