import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/auth/domain/entities/entities.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.token,
    required super.disabled,
    required super.role,
  });

  factory UserModel.fromJson(Json json) {
    return UserModel(
      id: json['user']['id'],
      username: json['user']['username'],
      token: json['token'],
      disabled: json['user']['disabled'],
      role: json['user']['role'],
    );
  }

  Json toJson() {
    return {
      'id': super.id,
      'name': super.username,
      'token': super.token,
      'disabled': super.disabled,
      'role': super.role,
    };
  }
}
