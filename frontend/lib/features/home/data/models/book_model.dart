import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';

class BookModel extends Book {
  BookModel({
    required super.code,
    required super.title,
    required super.author,
    required super.description,
    required super.quantity,
    required super.reservedQuantity,
  });

  factory BookModel.fromJson(Json json) {
    return BookModel(
      code: json['code'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      quantity: json['quantity'],
      reservedQuantity: json['reserved_quantity'],
    );
  }

  Json toJson() {
    return {
      'code': code,
      'title': title,
      'author': author,
      'description': description,
      'quantity': quantity,
      'reservedQuantity': reservedQuantity,
    };
  }
}
