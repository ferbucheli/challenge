part of 'books_bloc.dart';

sealed class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

final class BooksInitial extends BooksState {}

class EmptyBooks extends BooksState {}

class LoadingBooks extends BooksState {}

class LoadedBooks extends BooksState {
  final List<Book> books;

  LoadedBooks({required this.books});

  @override
  List<Object> get props => [books];
}

class ErrorBooks extends BooksState {
  final String message;

  ErrorBooks({required this.message});

  @override
  List<Object> get props => [message];
}

class BookReturned extends BooksState {}
