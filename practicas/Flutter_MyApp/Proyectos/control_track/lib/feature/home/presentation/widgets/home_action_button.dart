import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botón de acción personalizado para la página principal.
///
/// Botón con ancho completo que incluye un ícono y texto,
/// diseñado para las acciones principales del home (registrar, buscar).
///
/// **Características:**
/// - Ancho completo (double.infinity)
/// - Ícono y texto personalizables
/// - Color de fondo configurable
/// - Elevación y bordes redondeados
/// - Tipografía Montserrat
///
/// **Parámetros:**
/// - [icon]: Ícono a mostrar en el botón
/// - [label]: Texto descriptivo de la acción
/// - [color]: Color de fondo del botón
/// - [onTap]: Callback al presionar el botón
///
/// **Uso:**
/// ```dart
/// HomeActionButton(
///   icon: Icons.person_add,
///   label: 'Registrar usuario',
///   color: Color(0xFF0A8754),
///   onTap: () => Navigator.push(...),
/// )
/// ```
class HomeActionButton extends StatelessWidget {
  /// Ícono que se muestra a la izquierda del botón
  final IconData icon;

  /// Texto descriptivo de la acción del botón
  final String label;

  /// Color de fondo del botón
  final Color color;

  /// Callback ejecutado cuando se presiona el botón
  final VoidCallback onTap;

  const HomeActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 26),
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
