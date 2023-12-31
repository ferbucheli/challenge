class ServerException implements Exception {
  final String? message;

  const ServerException({this.message});
}

class CacheException implements Exception {}

class InvalidCredentialsException implements ServerException {
  @override
  final String message;

  InvalidCredentialsException(this.message);
}

class BookErrorException implements ServerException {
  @override
  final String message;

  BookErrorException(this.message);
}

class InvalidTokenException implements Exception {}
