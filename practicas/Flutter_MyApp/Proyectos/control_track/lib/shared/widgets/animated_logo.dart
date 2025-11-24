import 'package:flutter/material.dart';

/// Widget de logo SENA con animación de rebote al aparecer
///
/// Muestra el logo institucional dentro de un avatar circular con
/// una animación elástica de entrada.
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
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
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.account_circle, size: 70, color: Colors.green[700]),
          ),
        ),
      ),
    );
  }
}
