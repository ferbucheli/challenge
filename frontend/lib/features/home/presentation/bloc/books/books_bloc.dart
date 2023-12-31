import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/features/home/domain/usecases/create_book.dart';
import 'package:frontend/features/home/domain/usecases/return_book.dart';
import 'package:frontend/features/home/domain/usecases/usecases.dart';

import '../../../../../core/error/error.dart';
import '../../../domain/entities/entities.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  String SERVER_FAILURE_MESSAGE = 'Server Failure';
  String CACHE_FAILURE_MESSAGE = 'Cache Failure';

  final GetBooks getBooks;
  final ReturnBook returnBook;
  final CreateBook createBook;

  BooksBloc({
    required this.getBooks,
    required this.returnBook,
    required this.createBook,
  }) : super(BooksInitial()) {
    on<GetBooksEvent>(_onGetBooksRequested);
    on<ReturnBookEvent>(_onReturnBookRequested);
    on<CreateBookEvent>(_onCreateBookRequested);
    add(GetBooksEvent());
  }

  Future<void> _onGetBooksRequested(
      GetBooksEvent event, Emitter<BooksState> emit) async {
    emit(LoadingBooks());
    final failureOrBooks = await getBooks(NoParams());
    failureOrBooks!.fold(
      (failure) => emit(ErrorBooks(message: _mapFailureToMessage(failure))),
      (books) => emit(LoadedBooks(books: books)),
    );
  }

  Future<void> _onReturnBookRequested(
      ReturnBookEvent event, Emitter<BooksState> emit) async {
    emit(LoadingBooks());
    final failureOrBooks =
        await returnBook(ReturnBookParams(bookCode: event.bookCode));
    failureOrBooks!.fold(
      (failure) => emit(ErrorBooks(message: _mapFailureToMessage(failure))),
      (books) => emit(BookReturned()),
    );
  }

  Future<void> _onCreateBookRequested(
      CreateBookEvent event, Emitter<BooksState> emit) async {
    emit(LoadingBooks());
    final failureOrBook = await createBook(CreateBookParams(book: event.book));
    failureOrBook!.fold(
      (failure) => emit(ErrorBooks(message: _mapFailureToMessage(failure))),
      (books) => emit(BookCreated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
