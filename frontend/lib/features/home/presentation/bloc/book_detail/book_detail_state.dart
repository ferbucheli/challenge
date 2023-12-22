part of 'book_detail_bloc.dart';

sealed class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object> get props => [];
}

final class BookDetailInitial extends BookDetailState {}

final class BookDetailLoading extends BookDetailState {}

final class BookDetailLoaded extends BookDetailState {
  final Book book;

  BookDetailLoaded(this.book);

  @override
  List<Object> get props => [book];
}

class BookDetailError extends BookDetailState {
  final String message;

  BookDetailError(this.message);

  @override
  List<Object> get props => [message];
}
