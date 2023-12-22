import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String code;
  final String title;
  final String author;
  final String description;
  final int quantity;
  final int reservedQuantity;

  const Book({
    required this.code,
    required this.title,
    required this.author,
    required this.description,
    required this.quantity,
    required this.reservedQuantity,
  });

  @override
  List<Object?> get props => [
        code,
        title,
        author,
        description,
        quantity,
        reservedQuantity,
      ];
}
