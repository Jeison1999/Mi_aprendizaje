import 'package:flutter_firebase_base/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_base/src/models/paciente.dart';
import 'package:flutter_firebase_base/src/screens/ordenes_screen.dart';
import 'package:flutter_firebase_base/src/screens/resultados_screen.dart';
import 'firebase_options.dart'; // generado por FlutterFire CLI
import 'src/screens/login_screen.dart';
import 'src/screens/perfil_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Base',
      initialRoute: '/',
      routes: {
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Paciente) {
            return HomeScreen(paciente: args);
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error: No se recibió información del paciente.'),
              ),
            );
          }
        },
        '/': (context) => FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text('Error al conectar con Firebase')),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
        '/perfil': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is Paciente) {
            return PerfilScreen(paciente: args);
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Error: No se recibió información del paciente.'),
              ),
            );
          }
        },
        '/ordenes': (context) {
          final numeroId = ModalRoute.of(context)!.settings.arguments as String;
          return OrdenesScreen(idDocumento: numeroId);
        },
        '/resultados': (context) {
          final idOrden = ModalRoute.of(context)!.settings.arguments as String;
          return ResultadosScreen(idOrden: idOrden);
        },
      },
    );
  }
}

// ...existing code...

// The login and register logic should be handled inside LoginScreen (src/screens/login_screen.dart).
// Remove this duplicate code from main.dart.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestore.collection("items").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          return ListView(
            children: docs
                .map(
                  (doc) => ListTile(
                    title: Text(doc["title"]),
                    subtitle: Text(doc.id),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          firestore.collection("items").doc(doc.id).delete(),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await firestore.collection("items").add({"title": "Nuevo item"});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
