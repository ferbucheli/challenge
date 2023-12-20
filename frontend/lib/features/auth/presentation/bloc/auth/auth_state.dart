part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Empty extends AuthState {}

class Checking extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class Error extends AuthState {
  final String message;

  const Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class AuthInitial extends AuthState {}
