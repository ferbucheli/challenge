import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/error.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';
import 'package:frontend/features/home/domain/usecases/usecases.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  String SERVER_FAILURE_MESSAGE = 'Server Failure';
  String CACHE_FAILURE_MESSAGE = 'Cache Failure';

  final GetBook getBook;

  BookDetailBloc({
    required this.getBook,
  }) : super(BookDetailInitial()) {
    on<GetBookEvent>(_onGetBookRequested);
  }

  Future<void> _onGetBookRequested(
      GetBookEvent event, Emitter<BookDetailState> emit) async {
    emit(BookDetailLoading());
    await Future.delayed(const Duration(seconds: 2));
    final failureOrBook = await getBook(GetBookParams(event.bookCode));
    failureOrBook!.fold(
      (failure) => emit(BookDetailError(_mapFailureToMessage(failure))),
      (book) => emit(BookDetailLoaded(book)),
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
