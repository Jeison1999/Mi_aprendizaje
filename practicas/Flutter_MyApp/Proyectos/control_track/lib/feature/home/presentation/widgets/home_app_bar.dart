import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppBar personalizada para la página principal.
///
/// Barra de navegación transparente que muestra el título de la aplicación,
/// el email del usuario actual y un botón para cerrar sesión.
///
/// **Características:**
/// - Fondo transparente para integrarse con gradiente
/// - Muestra email del usuario autenticado
/// - Botón de logout con confirmación
/// - Tipografía Montserrat
///
/// **Uso:**
/// ```dart
/// Scaffold(
///   appBar: HomeAppBar(),
///   body: ...,
/// )
/// ```
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email ?? 'Usuario';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título principal
          Text(
            'Panel principal',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          // Subtítulo con email del usuario
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Text(
                userEmail,
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        // Botón de cerrar sesión
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => _handleLogout(context),
          tooltip: 'Cerrar sesión',
        ),
      ],
    );
  }

  /// Maneja el proceso de cierre de sesión.
  ///
  /// Cierra la sesión de Firebase y navega al login.
  /// Mantiene las credenciales biométricas si fueron guardadas previamente.
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Cerrar sesión en Firebase
      await FirebaseAuth.instance.signOut();

      // Navegar al login si el contexto sigue montado
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      // Manejar errores de cierre de sesión
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
