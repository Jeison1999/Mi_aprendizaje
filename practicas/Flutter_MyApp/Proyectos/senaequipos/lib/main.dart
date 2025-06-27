import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injector.dart';
import 'presentation/pages/registro_equipo_page.dart';
import 'presentation/pages/listar_registros_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/widgets/bubble.dart';

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
    return MaterialApp(
      title: 'SENA Equipos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF39A900), // Color verde SENA
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 6,
            shadowColor: Colors.black26,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF39A900),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        title: SizedBox(
          height: 35,
          child: Image.asset(
            'assets/pripro.png',
            fit: BoxFit.contain,
            semanticLabel: 'Logo institucional',
          ),
        ),
        centerTitle: true,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width > 400 ? 48 : 16,
                        vertical: 24,
                      ),
                      elevation: 14,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 36,
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.devices_other_rounded,
                              size: 100,
                              color: Color(0xFF39A900),
                              semanticLabel: 'Icono de equipos',
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Sistema de Gestión de Equipos',
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF222222),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'SENA - Servicio Nacional de Aprendizaje',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 36),
                            SizedBox(
                              width: size.width > 400 ? 320 : double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 28,
                                ),
                                label: const Text('Registrar nuevo equipo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF39A900),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black26,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RegistroEquipoPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: size.width > 400 ? 320 : double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.list_alt_rounded,
                                  size: 28,
                                ),
                                label: const Text('Ver registros de equipos'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[700],
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black26,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ListarRegistrosPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
