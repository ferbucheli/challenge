import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/features/home/data/models/models.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/shared/data/services/services.dart';

import '../../../../core/constants/constants.dart';

abstract class HomeRemoteDataSource {
  Future<List<Book>> getBooks();
  Future<List<Loan>> getLoans();
  Future<Book> getBook(String bookCode);
  Future<void> reserveBook(String bookCode);
  Future<void> cancelReservation(String bookCode);
  Future<void> returnBook(String bookCode);
  Future<void> deleteBook(String bookCode);
  Future<Book> createBook(Book book);
  Future<List<Loan>> getLoansByUser(String userId);
  Future<void> confirmReservation(String bookCode);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _client;
  final KeyValueStorageServiceImpl keyValueStorageService;

  HomeRemoteDataSourceImpl(
    this._client,
    this.keyValueStorageService,
  );
  @override
  Future<Book> createBook(Book book) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      final data = jsonEncode({
        'code': book.code,
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'quantity': book.quantity,
      });
      print('Sending data: $data');
      _client.options.headers = headers;
      final result = await _client.post(
        createBookUrl,
        data: data,
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo crear el libro');
      }

      return BookModel.fromJson(result.data['data']);
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print('Error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteBook(String bookCode) {
    // TODO: implement deleteBook
    throw UnimplementedError();
  }

  @override
  Future<Book> getBook(String bookCode) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.get(
        '$getBooksUrl/$bookCode',
        options: Options(contentType: Headers.jsonContentType),
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo obtener los libros');
      }
      return BookModel.fromJson(result.data['data']);
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Book>> getBooks() async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.get(
        getBooksUrl,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo obtener los libros');
      }

      return (result.data as List).map((e) => BookModel.fromJson(e)).toList();
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Loan>> getLoans() async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.get(
        '$getAllLoansUrl',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print(result.data);
      if (result.data == null) {
        throw BookErrorException('No se pudo obtener los libros');
      }
      return List<LoanModel>.from(
          result.data['data'].map((e) => LoanModel.fromJson(e)));
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print('error1 $e');
      throw ServerException();
    }
  }

  @override
  Future<List<Loan>> getLoansByUser(String userId) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.get(
        '$getLoansUrl/$userId/loans',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print(result.data);
      if (result.data == null) {
        throw BookErrorException('No se pudo obtener los libros');
      }
      return List<LoanModel>.from(
          result.data['data'].map((e) => LoanModel.fromJson(e)));
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print('error1 $e');
      throw ServerException();
    }
  }

  @override
  Future<void> reserveBook(String bookCode) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.post(
        '$getBooksUrl/$bookCode/reserve',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo reservar el libro');
      }

      return;
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<void> returnBook(String bookCode) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.post(
        '$returnBookUrl/$bookCode/return',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo regresar el libro');
      }

      return;
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<void> cancelReservation(String bookCode) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.post(
        '$getBooksUrl/$bookCode/cancel_reservation',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null) {
        throw BookErrorException(
            'No se pudo cancelar la reserva del libro $bookCode');
      }

      return;
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<void> confirmReservation(String bookCode) async {
    try {
      final token = await keyValueStorageService.getValue<String>('token');
      var headers = {
        "accept": 'application/json',
        "Authorization": "Bearer $token"
      };
      _client.options.headers = headers;
      final result = await _client.post(
        '$createLoan/$bookCode/confirm',
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (result.data == null) {
        throw BookErrorException('No se pudo prestar el libro $bookCode');
      }

      return;
    } on BookErrorException {
      rethrow;
    } catch (e) {
      print(e);
      throw ServerException();
    }
  }
}
