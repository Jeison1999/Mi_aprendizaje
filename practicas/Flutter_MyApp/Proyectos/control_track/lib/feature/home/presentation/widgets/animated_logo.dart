import 'package:flutter/material.dart';

/// Widget que muestra el logo del SENA con una animación de rebote al cargar.
///
/// El logo aparece con una animación elástica utilizando[Curves.elasticOut]
/// para crear un efecto visual atractivo al inicializar la página.
///
/// **Características:**
/// - Animación de entrada con rebote (1.2 segundos)
/// - Tamaño fijo de 48px de radio
/// - Carga de imagen desde assets con fallback
/// - Compatible con [Hero] animation
///
/// **Uso:**
/// ```dart
/// Hero(
///   tag: 'logo_sena',
///   child: AnimatedLogo(),
/// )
/// ```
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Controlador para animación de 1.2 segundos
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Curva elástica para efecto de rebote
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    // Iniciar animación al cargar
    _controller.forward();
  }

  @override
  void dispose() {
    // Liberar recursos del controlador
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo_sena.png',
            fit: BoxFit.contain,
            height: 70,
            // Fallback en caso de que el asset no se encuentre
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.account_circle, size: 70, color: Colors.green[700]),
          ),
        ),
      ),
    );
  }
}
