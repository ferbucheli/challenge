import 'package:equatable/equatable.dart';

class Loan extends Equatable {
  final String id;
  final String bookCode;
  final String studentId;
  final DateTime issueDate;
  final DateTime returnDate;
  final String status;

  const Loan({
    required this.id,
    required this.bookCode,
    required this.studentId,
    required this.issueDate,
    required this.returnDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        bookCode,
        studentId,
        issueDate,
        returnDate,
        status,
      ];
}
