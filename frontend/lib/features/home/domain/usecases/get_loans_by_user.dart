import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/repositories/home_repository.dart';

import '../../../../core/error/error.dart';

class GetLoansByUser extends UseCase<List<Loan>, GetLoansByUserParams> {
  final HomeRepository repository;

  GetLoansByUser({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<Loan>>?> call(GetLoansByUserParams params) async {
    return await repository.getLoansByUser(params.userId);
  }
}

class GetLoansByUserParams extends Equatable {
  final String userId;

  GetLoansByUserParams({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}
