import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/auth/domain/entities/entities.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.photoUrl,
  });

  factory UserModel.fromJson(Json json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Json toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'email': super.email,
      'photoUrl': super.photoUrl,
    };
  }
}
