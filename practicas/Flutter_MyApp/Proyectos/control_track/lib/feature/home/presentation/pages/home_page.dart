import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importaciones de páginas
import '../../../users/presentation/pages/register_user_page.dart';
import '../../../users/presentation/pages/user_search_page.dart';

// Importación de widgets del home
import '../widgets/widgets.dart';

/// Página principal de la aplicación Control Track.
///
/// Muestra un panel con acciones rápidas para gestionar usuarios
/// y pertenencias. Incluye navegación a registro y búsqueda de usuarios.
///
/// **Características:**
/// - Fondo animado con gradiente institucional
/// - Logo animado del SENA
/// - Botones de acción para flujos principales
/// - AppBar con información del usuario y logout
/// - Animaciones de entrada secuenciales
///
/// **Navegación:**
/// - Registrar usuario → [RegisterUserPage]
/// - Buscar usuario → [UserSearchPage]
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // AppBar personalizada con info del usuario
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          // Fondo degradado animado
          const AnimatedGradientBackground(),

          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Logo con animación de rebote
                    const Hero(tag: 'logo_sena', child: AnimatedLogo()),
                    const SizedBox(height: 18),

                    // Título principal con animación de entrada
                    AnimatedEntrance(
                      delay: 200,
                      child: Text(
                        'Control Track SENA',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtítulo con animación
                    AnimatedEntrance(
                      delay: 400,
                      child: Text(
                        'Gestión moderna y segura',
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Panel de acciones con animación
                    AnimatedEntrance(
                      delay: 600,
                      child: _buildActionsPanel(context, size),
                    ),
                    const SizedBox(height: 36),

                    // Footer con animación
                    AnimatedEntrance(
                      delay: 800,
                      child: Text(
                        'SENA - Innovación y control',
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el panel de botones de acción.
  ///
  /// Incluye botones para registrar y buscar usuarios con estilos
  /// personalizados y navegación a páginas correspondientes.
  Widget _buildActionsPanel(BuildContext context, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF0A8754).withOpacity(0.10),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón de registrar usuario
          HomeActionButton(
            icon: Icons.person_add_alt_1,
            label: 'Registrar usuario',
            color: const Color(0xFF0A8754),
            onTap: () => _navigateToRegisterUser(context),
          ),
          const SizedBox(height: 18),

          // Botón de buscar usuario
          HomeActionButton(
            icon: Icons.search,
            label: 'Buscar usuario',
            color: const Color(0xFF00C897),
            onTap: () => _navigateToSearchUser(context),
          ),
        ],
      ),
    );
  }

  /// Navega a la página de registro de usuario.
  void _navigateToRegisterUser(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterUserPage()));
  }

  /// Navega a la página de búsqueda de usuario.
  void _navigateToSearchUser(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const UserSearchPage()));
  }
}
