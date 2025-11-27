import 'package:firebase_auth/firebase_auth.dart';

/// Servicio para gestionar autenticación
class AuthService {
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
