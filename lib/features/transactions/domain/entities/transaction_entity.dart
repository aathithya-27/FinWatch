import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final String description;
  final String category;
  final TransactionType type;
  final DateTime date;
  final String? source;
  final String? destination;
  final String? notes;
  final bool isRecurring;
  final String? recurringPattern;
  final List<String>? tags;
  final String? location;
  final String? paymentMethod;
  final bool isAutoDetected;
  final String? originalMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.type,
    required this.date,
    this.source,
    this.destination,
    this.notes,
    this.isRecurring = false,
    this.recurringPattern,
    this.tags,
    this.location,
    this.paymentMethod,
    this.isAutoDetected = false,
    this.originalMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        category,
        type,
        date,
        source,
        destination,
        notes,
        isRecurring,
        recurringPattern,
        tags,
        location,
        paymentMethod,
        isAutoDetected,
        originalMessage,
        createdAt,
        updatedAt,
        userId,
      ];

  TransactionEntity copyWith({
    String? id,
    double? amount,
    String? description,
    String? category,
    TransactionType? type,
    DateTime? date,
    String? source,
    String? destination,
    String? notes,
    bool? isRecurring,
    String? recurringPattern,
    List<String>? tags,
    String? location,
    String? paymentMethod,
    bool? isAutoDetected,
    String? originalMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      originalMessage: originalMessage ?? this.originalMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  bool get isTransfer => type == TransactionType.transfer;

  String get formattedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return '🍽️';
      case 'shopping':
        return '🛍️';
      case 'transportation':
        return '🚗';
      case 'bills & utilities':
        return '💡';
      case 'entertainment':
        return '🎬';
      case 'healthcare':
        return '🏥';
      case 'education':
        return '📚';
      case 'travel':
        return '✈️';
      case 'groceries':
        return '🛒';
      case 'fuel':
        return '⛽';
      case 'salary':
        return '💰';
      case 'freelance':
        return '💻';
      case 'investment':
        return '📈';
      case 'business':
        return '🏢';
      case 'rental':
        return '🏠';
      case 'gift':
        return '🎁';
      case 'refund':
        return '↩️';
      default:
        return '💳';
    }
  }

  @override
  String toString() {
    return 'TransactionEntity(id: $id, amount: $amount, description: $description, type: $type, date: $date)';
  }
}