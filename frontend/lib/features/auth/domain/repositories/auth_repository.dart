import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>?> login(String email, String password);
}
