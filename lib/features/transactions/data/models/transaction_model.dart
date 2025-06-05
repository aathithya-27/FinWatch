import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final TransactionType type;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? source;

  @HiveField(7)
  final String? destination;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final bool isRecurring;

  @HiveField(10)
  final String? recurringPattern;

  @HiveField(11)
  final List<String>? tags;

  @HiveField(12)
  final String? location;

  @HiveField(13)
  final String? paymentMethod;

  @HiveField(14)
  final bool isAutoDetected;

  @HiveField(15)
  final String? originalMessage;

  @HiveField(16)
  final DateTime createdAt;

  @HiveField(17)
  final DateTime updatedAt;

  @HiveField(18)
  final String userId;

  TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      description: entity.description,
      category: entity.category,
      type: entity.type,
      date: entity.date,
      source: entity.source,
      destination: entity.destination,
      notes: entity.notes,
      isRecurring: entity.isRecurring,
      recurringPattern: entity.recurringPattern,
      tags: entity.tags,
      location: entity.location,
      paymentMethod: entity.paymentMethod,
      isAutoDetected: entity.isAutoDetected,
      originalMessage: entity.originalMessage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      userId: entity.userId,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      description: description,
      category: category,
      type: type,
      date: date,
      source: source,
      destination: destination,
      notes: notes,
      isRecurring: isRecurring,
      recurringPattern: recurringPattern,
      tags: tags,
      location: location,
      paymentMethod: paymentMethod,
      isAutoDetected: isAutoDetected,
      originalMessage: originalMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
    );
  }

  TransactionModel copyWith({
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
    return TransactionModel(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, description: $description, type: $type, date: $date)';
  }
}

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}

// Adapter classes will be generated by build_runner
class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      amount: fields[1] as double,
      description: fields[2] as String,
      category: fields[3] as String,
      type: fields[4] as TransactionType,
      date: fields[5] as DateTime,
      source: fields[6] as String?,
      destination: fields[7] as String?,
      notes: fields[8] as String?,
      isRecurring: fields[9] as bool,
      recurringPattern: fields[10] as String?,
      tags: (fields[11] as List?)?.cast<String>(),
      location: fields[12] as String?,
      paymentMethod: fields[13] as String?,
      isAutoDetected: fields[14] as bool,
      originalMessage: fields[15] as String?,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
      userId: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.destination)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.isRecurring)
      ..writeByte(10)
      ..write(obj.recurringPattern)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.paymentMethod)
      ..writeByte(14)
      ..write(obj.isAutoDetected)
      ..writeByte(15)
      ..write(obj.originalMessage)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 2;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      case 2:
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
      case TransactionType.transfer:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}