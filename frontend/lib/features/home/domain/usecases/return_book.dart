import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/repositories/home_repository.dart';

class ReturnBook implements UseCase<void, ReturnBookParams> {
  final HomeRepository repository;

  ReturnBook(this.repository);

  @override
  Future<Either<Failure, void>?> call(ReturnBookParams params) async {
    return await repository.returnBook(params.bookCode);
  }
}

class ReturnBookParams extends Equatable {
  final String bookCode;

  ReturnBookParams({
    required this.bookCode,
  });

  @override
  List<Object> get props => [bookCode];
}
