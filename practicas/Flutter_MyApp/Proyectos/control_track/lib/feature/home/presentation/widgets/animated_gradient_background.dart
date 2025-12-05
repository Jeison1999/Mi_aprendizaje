import 'package:flutter/material.dart';

/// Widget que muestra un fondo con gradiente animado entre colores institucionales.
///
/// El gradiente transiciona suavemente entre verde SENA (#0A8754)
/// y verde claro (#00C897) creando un efecto visual dinámico.
///
/// **Características:**
/// - Animación de 8 segundos con repetición inversa
/// - Transición suave con [Curves.easeInOut]
/// - Colores institucionales del SENA
///
/// **Uso:**
/// ```dart
/// Stack(
///   children: [
///     AnimatedGradientBackground(),
///     // Contenido de la página
///   ],
/// )
/// ```
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Inicializar controlador de animación con duración de 8 segundos
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true); // Repetir en reversa para efecto continuo

    // Aplicar curva de animación suave
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    // Liberar recursos del controlador
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Interpolar entre verde oscuro y claro según el valor de animación
                Color.lerp(
                  const Color(0xFF0A8754), // Verde SENA
                  const Color(0xFF00C897), // Verde claro
                  _animation.value,
                )!,
                // Color inverso para crear efecto de flujo
                Color.lerp(
                  const Color(0xFF00C897),
                  const Color(0xFF0A8754),
                  _animation.value,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}
