import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/features/auth/domain/entities/entities.dart';
import 'package:frontend/features/auth/domain/repositories/repositories.dart';

import '../../../../core/usecases/usecase.dart';

class Login implements UseCase<User, Params> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>?> call(Params params) async {
    return await repository.login(params.username, params.password);
  }
}

class Params extends Equatable {
  final String username;
  final String password;

  const Params({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
