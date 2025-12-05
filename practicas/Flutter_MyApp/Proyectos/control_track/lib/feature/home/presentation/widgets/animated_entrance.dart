import 'package:flutter/material.dart';

/// Widget wrapper que añade una animación de entrada suave a su hijo.
///
/// El widget hijo aparece gradualmente con un efecto de fade-in
/// y desplazamiento hacia arriba, creando una entrada visual elegante.
///
/// **Características:**
/// - Delay configurable antes de iniciar la animación
/// - Duración de 700ms para transición suave
/// - Curva [Curves.easeOutBack] para efecto natural
/// - Combinacombinación de opacity y translateY
///
/// **Parámetros:**
/// - [child]: Widget que se animará
/// - [delay]: Retraso en milisegundos antes de iniciar (default: 0)
///
/// **Uso:**
/// ```dart
/// AnimatedEntrance(
///   delay: 200,
///   child: Text('Título animado'),
/// )
/// ```
class AnimatedEntrance extends StatelessWidget {
  /// Widget hijo que recibirá la animación
  final Widget child;

  /// Tiempo de espera en milisegundos antes de iniciar la animación
  final int delay;

  const AnimatedEntrance({required this.child, this.delay = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Esperar el delay configurado antes de mostrar
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        final show = snapshot.connectionState == ConnectionState.done;

        return TweenAnimationBuilder<double>(
          // Animar de 0 a 1 cuando show sea true
          tween: Tween(begin: 0, end: show ? 1 : 0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            // Fade in: 0 (transparente) → 1 (opaco)
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              // Slide up: +30px → 0px
              offset: Offset(0, (1 - value) * 30),
              child: child,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
