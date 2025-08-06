import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? usuario;

  const HomeScreen({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home Screen\nUsuario: \\${usuario != null ? usuario.toString() : "No info"}',
        ),
        // Puedes personalizar la visualización del usuario aquí
      ),
    );
  }
}
