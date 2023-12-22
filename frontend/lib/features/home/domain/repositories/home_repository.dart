import 'package:dartz/dartz.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';

import '../../../../core/error/error.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Book>>?> getBooks();
  Future<Either<Failure, List<Loan>>?> getLoans();
  Future<Either<Failure, Book>?> getBook(String bookCode);
  Future<Either<Failure, void>?> reserveBook(String bookCode);
  Future<Either<Failure, void>?> cancelReservation(String bookCode);
  Future<Either<Failure, void>?> confirmReservation(String bookCode);
  Future<Either<Failure, void>?> returnBook(String bookCode);
  Future<Either<Failure, void>?> deleteBook(String bookCode);
  Future<Either<Failure, Book>?> createBook(Book book);
  Future<Either<Failure, List<Loan>>?> getLoansByUser(String userId);
}
