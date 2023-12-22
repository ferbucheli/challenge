import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

class CreateBook extends UseCase<Book, CreateBookParams> {
  final HomeRepository repository;

  CreateBook(this.repository);

  @override
  Future<Either<Failure, Book>?> call(CreateBookParams params) async {
    return await repository.createBook(params.book);
  }
}

class CreateBookParams extends Equatable {
  final Book book;

  CreateBookParams({required this.book});

  @override
  List<Object?> get props => [book];
}
