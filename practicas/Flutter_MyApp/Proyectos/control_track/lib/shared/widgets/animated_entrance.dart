import 'package:flutter/material.dart';

/// Widget que anima la entrada de sus hijos con efecto de fade y slide desde abajo
///
/// Útil para crear transiciones suaves al mostrar contenido en pantalla.
/// El parámetro [delay] permite escalonar múltiples animaciones.
class AnimatedEntrance extends StatelessWidget {
  /// Widget hijo que será animado
  final Widget child;

  /// Retraso en milisegundos antes de iniciar la animación
  final int delay;

  const AnimatedEntrance({required this.child, this.delay = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        final show = snapshot.connectionState == ConnectionState.done;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: show ? 1 : 0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
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
