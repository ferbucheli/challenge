import 'package:formz/formz.dart';

// Define input validation errors
enum UsuarioError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Usuario extends FormzInput<String, UsuarioError> {
  // Call super.pure to represent an unmodified form input.
  const Usuario.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Usuario.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UsuarioError.empty) return 'El campo es requerido';
    if (displayError == UsuarioError.length)
      return 'No tiene formato de usuario';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UsuarioError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UsuarioError.empty;
    if (value.length < 3) return UsuarioError.length;

    return null;
  }
}
