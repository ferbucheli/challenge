import 'package:dio/dio.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/error/exceptions.dart';
import 'package:frontend/features/auth/data/models/models.dart';
import 'package:frontend/features/auth/domain/entities/entities.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<User> login(String username, String password) async {
    try {
      final result = await _client.post(
        loginUrl,
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null || result.data!['token'] == null) {
        throw InvalidCredentialsException('No se pudo iniciar sesión');
      }

      if (result.data == null) {
        throw ServerException();
      }
      return UserModel.fromJson(result.data!);
    } on InvalidCredentialsException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
