import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:labores_kfc/widgets/miembros_Equipo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Labores());
}

class Labores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Image.asset('assets/KFC.png', height: 18)),
        ),
        body: Miembros(),
      ),
    );
  }
}
