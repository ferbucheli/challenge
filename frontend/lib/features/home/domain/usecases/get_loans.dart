import 'package:dartz/dartz.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/repositories/home_repository.dart';

import '../../../../core/error/error.dart';

class GetLoans implements UseCase<List<Loan>, NoParams> {
  final HomeRepository repository;

  GetLoans(this.repository);

  @override
  Future<Either<Failure, List<Loan>>?> call(NoParams params) async {
    return await repository.getLoans();
  }
}
