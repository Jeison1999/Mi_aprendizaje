import 'package:flutter/material.dart';

class HomeCliente extends StatelessWidget {
  final Map<String, dynamic> usuario;

  HomeCliente({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenido ${usuario['nombre']}")),
      body: Center(child: Text("Vista del Cliente")),
    );
  }
}
