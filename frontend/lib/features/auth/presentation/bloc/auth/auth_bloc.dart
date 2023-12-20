import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/usecases/login.dart';
import 'package:frontend/features/shared/data/services/services.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final KeyValueStorageServiceImpl keyValueStorageService;

  AuthBloc({
    required this.loginUseCase,
    required this.keyValueStorageService,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginRequested);
    on<LogoutEvent>(_onLogoutRequested);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(Checking());
    final failureOrUser = await loginUseCase(
        Params(username: event.username, password: event.password));
    failureOrUser!.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (user) async {
        emit(Authenticated(user: user));
        await keyValueStorageService.setKeyValue('token', user.token);
        await keyValueStorageService.setKeyValue('username', user.username);
        await keyValueStorageService.setKeyValue('password', event.password);
      },
    );
  }

  Future<void> _onLogoutRequested(
      LogoutEvent event, Emitter<AuthState> emit) async {
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('username');
    await keyValueStorageService.removeKey('password');
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(Checking());
    final token = await keyValueStorageService.getValue<String>('token');
    final username = await keyValueStorageService.getValue<String>('username');
    final password = await keyValueStorageService.getValue<String>('password');

    if (token == null || username == null || password == null) {
      add(LogoutEvent());
    } else {
      add(LoginEvent(username: username, password: password));
    }
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
