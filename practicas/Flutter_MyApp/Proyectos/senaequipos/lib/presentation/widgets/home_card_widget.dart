import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';

class HomeCardWidget extends StatelessWidget {
  final Size size;
  final VoidCallback onRegisterPressed;
  final VoidCallback onListPressed;

  const HomeCardWidget({
    super.key,
    required this.size,
    required this.onRegisterPressed,
    required this.onListPressed,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => AnimatedOpacity(
            opacity: value.clamp(0.0, 1.0),
            duration: const Duration(milliseconds: 700),
            child: AnimatedSlide(
              offset: Offset(0, 1 - value),
              duration: const Duration(milliseconds: 700),
              child: child!,
            ),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            elevation: 14,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.devices_other_rounded,
                    size: 100,
                    color: AppColors.senaGreen,
                    semanticLabel: 'Icono de equipos',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sistema de Gestión de Equipos',
                    style: AppStyles.title(context).copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'SENA - Servicio Nacional de Aprendizaje',
                    style: AppStyles.subtitle(context).copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutBack,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 28,
                        ),
                        label: Text(
                          'Registrar nuevo equipo',
                          style: AppStyles.button(
                            context,
                          ).copyWith(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.senaGreen,
                          foregroundColor: Colors.white,
                          textStyle: AppStyles.button(
                            context,
                          ).copyWith(fontSize: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: AppStyles.buttonShape,
                          elevation: 8,
                          shadowColor: AppColors.buttonShadow,
                        ),
                        onPressed: () {
                          onRegisterPressed();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.list_alt_rounded, size: 28),
                        label: Text(
                          'Ver registros de equipos',
                          style: AppStyles.button(
                            context,
                          ).copyWith(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonAlt,
                          foregroundColor: Colors.white,
                          textStyle: AppStyles.button(
                            context,
                          ).copyWith(fontSize: 20),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          shape: AppStyles.buttonShape,
                          elevation: 8,
                          shadowColor: AppColors.buttonShadow,
                        ),
                        onPressed: () {
                          onListPressed();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
