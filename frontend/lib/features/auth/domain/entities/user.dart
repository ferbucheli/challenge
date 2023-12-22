import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String role;
  final String token;
  final bool disabled;

  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.token,
    required this.disabled,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        role,
        token,
        disabled,
      ];
}
