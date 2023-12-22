part of 'book_detail_bloc.dart';

sealed class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object> get props => [];
}

class GetBookEvent extends BookDetailEvent {
  final String bookCode;

  GetBookEvent(this.bookCode);
}
