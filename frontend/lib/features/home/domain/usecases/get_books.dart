import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

class GetBooks extends UseCase<List<Book>, NoParams> {
  final HomeRepository repository;

  GetBooks(this.repository);

  @override
  Future<Either<Failure, List<Book>>?> call(NoParams params) async {
    return await repository.getBooks();
  }
}
