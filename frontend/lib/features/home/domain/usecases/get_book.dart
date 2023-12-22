import 'package:dartz/dartz.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

import '../../../../core/error/error.dart';
import '../../../../core/usecases/usecase.dart';

class GetBook extends UseCase<Book, GetBookParams> {
  final HomeRepository repository;

  GetBook(this.repository);

  @override
  Future<Either<Failure, Book>?> call(GetBookParams params) async {
    return await repository.getBook(params.bookCode);
  }
}

class GetBookParams {
  final String bookCode;

  GetBookParams(this.bookCode);
}
