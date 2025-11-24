import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Servicio para gestionar autenticación biométrica y almacenamiento seguro de credenciales
class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  /// Verifica si el dispositivo soporta autenticación biométrica
  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      final bool canAuthenticate = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticate && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene la lista de biométricos disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Autentica al usuario usando biometría
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Autentícate para acceder a Control Track',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Guarda las credenciales de forma segura
  Future<void> saveCredentials(
    String email,
    String password,
    bool enableBiometric,
  ) async {
    await _secureStorage.write(key: _keyEmail, value: email);
    await _secureStorage.write(key: _keyPassword, value: password);
    await _secureStorage.write(
      key: _keyBiometricEnabled,
      value: enableBiometric.toString(),
    );
  }

  /// Obtiene las credenciales guardadas
  Future<Map<String, String>?> getStoredCredentials() async {
    final email = await _secureStorage.read(key: _keyEmail);
    final password = await _secureStorage.read(key: _keyPassword);

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  /// Verifica si la autenticación biométrica está habilitada
  Future<bool> isBiometricEnabled() async {
    final enabled = await _secureStorage.read(key: _keyBiometricEnabled);
    return enabled == 'true';
  }

  /// Obtiene el email del último usuario guardado
  Future<String?> getLastUserEmail() async {
    return await _secureStorage.read(key: _keyEmail);
  }

  /// Elimina las credenciales guardadas
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _keyEmail);
    await _secureStorage.delete(key: _keyPassword);
    await _secureStorage.delete(key: _keyBiometricEnabled);
  }

  /// Obtiene el email del usuario actualmente autenticado en Firebase
  String? getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  /// Obtiene el nombre para mostrar del usuario actual
  String? getCurrentUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email?.split('@').first;
  }

  /// Cierra la sesión del usuario
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
