import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';

class HomeCardWidget extends StatelessWidget {
  final Size size;
  final VoidCallback onRegisterPressed;
  final VoidCallback onListPressed;
  final void Function(String message)? onShowSnackBar;

  const HomeCardWidget({
    super.key,
    required this.size,
    required this.onRegisterPressed,
    required this.onListPressed,
    this.onShowSnackBar,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Definir un ancho máximo para la Card en escritorio
        double maxCardWidth = orientation == Orientation.landscape ? 600 : 480;
        double horizontalMargin = size.width > 600
            ? (size.width - maxCardWidth) / 2
            : 16;
        double cardWidth = size.width > maxCardWidth
            ? maxCardWidth
            : size.width - 2 * horizontalMargin;

        // Ajustar paddings y tamaños de fuente según el ancho y orientación
        double verticalPadding = orientation == Orientation.landscape
            ? 20
            : (size.width > 600 ? 48 : 32);
        double iconSize = orientation == Orientation.landscape
            ? 80
            : (size.width > 600 ? 120 : 100);
        double titleFontSize = orientation == Orientation.landscape
            ? 22
            : (size.width > 600 ? 32 : 28);
        double subtitleFontSize = orientation == Orientation.landscape
            ? 14
            : (size.width > 600 ? 18 : 16);
        double buttonFontSize = orientation == Orientation.landscape
            ? 16
            : (size.width > 600 ? 22 : 20);
        double buttonPaddingV = orientation == Orientation.landscape
            ? 12
            : (size.width > 600 ? 22 : 18);

        Widget cardContent = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.devices_other_rounded,
              size: iconSize,
              color: AppColors.senaGreen,
              semanticLabel: 'Icono de equipos',
            ),
            const SizedBox(height: 24),
            Text(
              'Sistema de Gestión de Equipos',
              style: AppStyles.title(context).copyWith(fontSize: titleFontSize),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'SENA - Servicio Nacional de Aprendizaje',
              style: AppStyles.subtitle(
                context,
              ).copyWith(fontSize: subtitleFontSize),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              child: SizedBox(
                width: cardWidth > 400 ? 320 : double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
                  label: Text(
                    'Registrar nuevo equipo',
                    style: AppStyles.button(
                      context,
                    ).copyWith(fontSize: buttonFontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.senaGreen,
                    foregroundColor: Colors.white,
                    textStyle: AppStyles.button(
                      context,
                    ).copyWith(fontSize: buttonFontSize),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: buttonPaddingV,
                    ),
                    shape: AppStyles.buttonShape,
                    elevation: 8,
                    shadowColor: AppColors.buttonShadow,
                  ),
                  onPressed: () {
                    if (onShowSnackBar != null) {
                      onShowSnackBar!("Navegando a registro de equipo");
                    }
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
                width: cardWidth > 400 ? 320 : double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.list_alt_rounded, size: 28),
                  label: Text(
                    'Ver registros de equipos',
                    style: AppStyles.button(
                      context,
                    ).copyWith(fontSize: buttonFontSize),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonAlt,
                    foregroundColor: Colors.white,
                    textStyle: AppStyles.button(
                      context,
                    ).copyWith(fontSize: buttonFontSize),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: buttonPaddingV,
                    ),
                    shape: AppStyles.buttonShape,
                    elevation: 8,
                    shadowColor: AppColors.buttonShadow,
                  ),
                  onPressed: () {
                    if (onShowSnackBar != null) {
                      onShowSnackBar!("Navegando a lista de registros");
                    }
                    onListPressed();
                  },
                ),
              ),
            ),
          ],
        );

        return Center(
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxCardWidth),
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: horizontalMargin,
                  vertical: 24,
                ),
                elevation: 14,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: verticalPadding,
                  ),
                  child: orientation == Orientation.landscape
                      ? SingleChildScrollView(child: cardContent)
                      : cardContent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
