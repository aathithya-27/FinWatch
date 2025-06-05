import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String? preferredCurrency;
  final String? timezone;
  final Map<String, dynamic>? preferences;
  final bool isOnboardingCompleted;
  final String? fcmToken;

  const UserEntity({
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

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        emailVerified,
        createdAt,
        lastLoginAt,
        preferredCurrency,
        timezone,
        preferences,
        isOnboardingCompleted,
        fcmToken,
      ];

  UserEntity copyWith({
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
    return UserEntity(
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

  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final names = displayName!.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      } else {
        return names[0][0].toUpperCase();
      }
    }
    return email[0].toUpperCase();
  }

  String get firstName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!.split(' ').first;
    }
    return email.split('@').first;
  }

  String get lastName {
    if (displayName != null && displayName!.isNotEmpty) {
      final names = displayName!.split(' ');
      if (names.length >= 2) {
        return names.last;
      }
    }
    return '';
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, displayName: $displayName)';
  }
}