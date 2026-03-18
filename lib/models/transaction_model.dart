import 'package:cloud_firestore/cloud_firestore.dart';

/// Categories for transactions as defined in REQUIREMENTS.md.
enum TransactionCategory {
  needs,
  wants,
  savings,
  others;

  String get displayName {
    switch (this) {
      case TransactionCategory.needs: return 'Needs';
      case TransactionCategory.wants: return 'Wants';
      case TransactionCategory.savings: return 'Savings';
      case TransactionCategory.others: return 'Others';
    }
  }

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransactionCategory.others,
    );
  }
}

/// A model representing a financial transaction.
class TransactionModel {
  final String? id;
  final String userId;
  final double amount;
  final TransactionCategory category;
  final DateTime date;
  final String? note;

  TransactionModel({
    this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data, String id) {
    return TransactionModel(
      id: id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: TransactionCategory.fromString(data['category'] ?? 'others'),
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category.name,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }
}
