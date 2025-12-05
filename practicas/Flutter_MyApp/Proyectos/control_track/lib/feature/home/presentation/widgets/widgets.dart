/// Widgets reutilizables de la página principal.
///
/// Este archivo exporta todos los widgets utilizados en el home
/// para facilitar su importación en otros archivos.
///
/// **Widgets disponibles:**
/// - [AnimatedGradientBackground]: Fondo con gradiente animado
/// - [AnimatedLogo]: Logo del SENA con animación de rebote
/// - [AnimatedEntrance]: Wrapper para animar entrada de widgets
/// - [HomeActionButton]: Botón de acción estilizado
/// - [HomeAppBar]: AppBar personalizada del home
///
/// **Uso:**
/// ```dart
/// import 'package:control_track/feature/home/presentation/widgets/widgets.dart';
///
/// // Todos los widgets están disponibles
/// HomeAppBar();
/// AnimatedGradientBackground();
/// // etc.
/// ```
library;

export 'animated_gradient_background.dart';
export 'animated_logo.dart';
export 'animated_entrance.dart';
export 'home_action_button.dart';
export 'home_app_bar.dart';
