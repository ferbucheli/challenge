part of 'books_bloc.dart';

sealed class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object> get props => [];
}

class GetBooksEvent extends BooksEvent {}

class ReturnBookEvent extends BooksEvent {
  final String bookCode;

  ReturnBookEvent({
    required this.bookCode,
  });

  @override
  List<Object> get props => [bookCode];
}
