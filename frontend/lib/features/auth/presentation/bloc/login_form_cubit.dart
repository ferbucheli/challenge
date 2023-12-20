import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../shared/data/inputs/inputs.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormState());

  void onUsernameChange(String value) {
    final newEmail = Usuario.dirty(value);
    emit(state.copyWith(
        usuario: newEmail,
        isValid: Formz.validate([newEmail, state.password])));
  }

  void onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    emit(state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.usuario])));
  }

  void touchEveryField() {
    final email = Usuario.dirty(state.usuario.value);
    final password = Password.dirty(state.password.value);

    emit(state.copyWith(
        isFormPosted: true,
        usuario: email,
        password: password,
        isValid: Formz.validate([email, password])));
  }
}

class LoginFormState extends Equatable {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Usuario usuario;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.usuario = const Usuario.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Usuario? usuario,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        usuario: usuario ?? this.usuario,
        password: password ?? this.password,
      );
  @override
  List<Object> get props =>
      [isPosting, isFormPosted, isValid, usuario, password];
}
