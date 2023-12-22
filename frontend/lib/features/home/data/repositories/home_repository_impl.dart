import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/network/network.dart';
import 'package:frontend/features/home/data/datasources/datasources.dart';
import 'package:frontend/features/home/domain/entities/book.dart';
import 'package:frontend/features/home/domain/entities/loan.dart';
import 'package:frontend/features/home/domain/repositories/repositories.dart';

class HomeRepositoryImpl extends HomeRepository {
  final NetworkInfo networkInfo;
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl({
    required this.networkInfo,
    required this.dataSource,
  });

  @override
  Future<Either<Failure, Book>?> createBook(Book book) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.createBook(book));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>?> deleteBook(String bookCode) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Book>?> getBook(String bookCode) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.getBook(bookCode));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Book>>?> getBooks() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.getBooks());
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Loan>>?> getLoans() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.getLoans());
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Loan>>?> getLoansByUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.getLoansByUser(userId));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>?> reserveBook(String bookCode) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.reserveBook(bookCode));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>?> returnBook(String bookCode) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.returnBook(bookCode));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>?> cancelReservation(String bookCode) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.cancelReservation(bookCode));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>?> confirmReservation(String bookCode) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.confirmReservation(bookCode));
      } on BookErrorException {
        return Left(BookErrorFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
