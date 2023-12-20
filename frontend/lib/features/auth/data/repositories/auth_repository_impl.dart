import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/network/network.dart';
import 'package:frontend/features/auth/data/datasources/datasources.dart';
import 'package:frontend/features/auth/domain/entities/entities.dart';
import 'package:frontend/features/auth/domain/repositories/repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.dataSource,
  });

  @override
  Future<Either<Failure, User>?> login(String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.login(username, password));
      } on InvalidCredentialsException {
        return Left(InvalidCredentialsFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
