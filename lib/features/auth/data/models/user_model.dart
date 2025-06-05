import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? displayName;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final String? phoneNumber;

  @HiveField(5)
  final bool emailVerified;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime lastLoginAt;

  @HiveField(8)
  final String? preferredCurrency;

  @HiveField(9)
  final String? timezone;

  @HiveField(10)
  final Map<String, dynamic>? preferences;

  @HiveField(11)
  final bool isOnboardingCompleted;

  @HiveField(12)
  final String? fcmToken;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified = false,
    required this.createdAt,
    required this.lastLoginAt,
    this.preferredCurrency = 'USD',
    this.timezone,
    this.preferences,
    this.isOnboardingCompleted = false,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      phoneNumber: entity.phoneNumber,
      emailVerified: entity.emailVerified,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
      preferredCurrency: entity.preferredCurrency,
      timezone: entity.timezone,
      preferences: entity.preferences,
      isOnboardingCompleted: entity.isOnboardingCompleted,
      fcmToken: entity.fcmToken,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      emailVerified: emailVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      preferredCurrency: preferredCurrency,
      timezone: timezone,
      preferences: preferences,
      isOnboardingCompleted: isOnboardingCompleted,
      fcmToken: fcmToken,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? preferredCurrency,
    String? timezone,
    Map<String, dynamic>? preferences,
    bool? isOnboardingCompleted,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      timezone: timezone ?? this.timezone,
      preferences: preferences ?? this.preferences,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName)';
  }
}

// Adapter class for Hive
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      photoUrl: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      emailVerified: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      lastLoginAt: fields[7] as DateTime,
      preferredCurrency: fields[8] as String?,
      timezone: fields[9] as String?,
      preferences: (fields[10] as Map?)?.cast<String, dynamic>(),
      isOnboardingCompleted: fields[11] as bool,
      fcmToken: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.emailVerified)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastLoginAt)
      ..writeByte(8)
      ..write(obj.preferredCurrency)
      ..writeByte(9)
      ..write(obj.timezone)
      ..writeByte(10)
      ..write(obj.preferences)
      ..writeByte(11)
      ..write(obj.isOnboardingCompleted)
      ..writeByte(12)
      ..write(obj.fcmToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}