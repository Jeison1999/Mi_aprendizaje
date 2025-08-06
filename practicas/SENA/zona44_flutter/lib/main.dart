import 'package:flutter/material.dart';
import 'screens/verificar_sesion.dart';

void main() {
  runApp(Zona44App());
}

class Zona44App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zona 44',
      home: VerificarSesion(),
      debugShowCheckedModeBanner: false,
    );
  }
}
