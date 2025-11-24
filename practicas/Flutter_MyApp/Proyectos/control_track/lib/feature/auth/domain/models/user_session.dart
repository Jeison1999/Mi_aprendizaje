import 'package:equatable/equatable.dart';

/// Modelo para representar la sesión del usuario autenticado
class UserSession extends Equatable {
  final String email;
  final String displayName;
  final DateTime loginTime;
  final bool hasBiometricEnabled;

  const UserSession({
    required this.email,
    required this.displayName,
    required this.loginTime,
    required this.hasBiometricEnabled,
  });

  @override
  List<Object?> get props => [
    email,
    displayName,
    loginTime,
    hasBiometricEnabled,
  ];

  UserSession copyWith({
    String? email,
    String? displayName,
    DateTime? loginTime,
    bool? hasBiometricEnabled,
  }) {
    return UserSession(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      loginTime: loginTime ?? this.loginTime,
      hasBiometricEnabled: hasBiometricEnabled ?? this.hasBiometricEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'loginTime': loginTime.toIso8601String(),
      'hasBiometricEnabled': hasBiometricEnabled,
    };
  }

  factory UserSession.fromMap(Map<String, dynamic> map) {
    return UserSession(
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      loginTime: DateTime.parse(map['loginTime'] as String),
      hasBiometricEnabled: map['hasBiometricEnabled'] as bool,
    );
  }
}
