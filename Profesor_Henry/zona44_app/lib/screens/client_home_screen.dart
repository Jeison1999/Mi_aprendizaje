import 'package:flutter/material.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zona 44 - Menú Cliente')),
      body: const Center(child: Text('Bienvenido, selecciona tus productos')),
    );
  }
}
