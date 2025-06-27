import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injector.dart';
import 'presentation/pages/registro_equipo_page.dart';
import 'presentation/pages/listar_registros_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/widgets/bubble.dart';
import 'core/utils/app_colors.dart';
import 'core/utils/app_styles.dart';
import 'presentation/widgets/home_card_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'core/utils/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar inyección de dependencias
  await initInjector();

  runApp(const SenaEquiposApp());
}

class SenaEquiposApp extends StatelessWidget {
  const SenaEquiposApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SENA Equipos',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.senaGreen, // Color verde SENA
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.montserratTextTheme(),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: AppStyles.buttonShape,
                  elevation: 6,
                  shadowColor: AppColors.buttonShadow,
                ),
              ),
              cardTheme: CardThemeData(
                color: AppColors.cardBackground,
                elevation: 8,
                shadowColor: AppColors.cardShadow,
                shape: AppStyles.cardShape,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.senaGreen,
                foregroundColor: AppColors.appBarForeground,
                elevation: 4,
                centerTitle: true,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.senaGreen,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.montserratTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: AppStyles.buttonShape,
                  elevation: 6,
                  shadowColor: AppColors.buttonShadow,
                ),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF232323),
                elevation: 8,
                shadowColor: Colors.black54,
                shape: AppStyles.cardShape,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.senaGreen,
                foregroundColor: Colors.white,
                elevation: 4,
                centerTitle: true,
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            'assets/pripro.png',
            fit: BoxFit.contain,
            height: 32,
            semanticLabel: 'Logo institucional',
          ),
        ),
        title: const Text('SENA Equipos'),
        centerTitle: true,
        actions: [
          // Botón de cambio de tema
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Cambiar tema (${themeProvider.getThemeModeName()})',
          ),
          if (kIsWeb ||
              defaultTargetPlatform == TargetPlatform.windows ||
              defaultTargetPlatform == TargetPlatform.macOS ||
              defaultTargetPlatform == TargetPlatform.linux)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'about', child: Text('Acerca de')),
                const PopupMenuItem(value: 'help', child: Text('Ayuda')),
              ],
              onSelected: (value) {
                // Aquí puedes mostrar un diálogo o navegar a otra página
              },
            ),
        ],
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Fondo decorativo con degradado y burbujas
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFFB6FFB0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: Bubble(color: Colors.white.withOpacity(0.08), size: 180),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: Bubble(color: Colors.white.withOpacity(0.10), size: 120),
          ),
          Center(
            child: SingleChildScrollView(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: HomeCardWidget(
                  size: size,
                  onRegisterPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegistroEquipoPage(),
                      ),
                    );
                  },
                  onListPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ListarRegistrosPage(),
                      ),
                    );
                  },
                  onShowSnackBar: (msg) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
