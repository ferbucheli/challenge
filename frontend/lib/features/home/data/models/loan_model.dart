import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/home/domain/entities/entities.dart';

class LoanModel extends Loan {
  LoanModel({
    required super.id,
    required super.bookCode,
    required super.studentId,
    required super.issueDate,
    required super.status,
    required super.returnDate,
  });

  factory LoanModel.fromJson(Json json) {
    return LoanModel(
      id: json['_id'],
      bookCode: json['book_code'],
      studentId: json['student_id'],
      issueDate: DateTime.parse(json['issue_date']),
      returnDate: DateTime.parse(json['return_date']),
      status: json['status'],
    );
  }

  Json toJson() {
    return {
      'id': id,
      'bookCode': bookCode,
      'userId': studentId,
      'loanDate': issueDate.toIso8601String(),
      'returnDate': returnDate.toIso8601String(),
      'status': status,
    };
  }
}
