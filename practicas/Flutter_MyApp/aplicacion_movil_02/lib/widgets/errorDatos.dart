// ErrorDatos
import 'package:flutter/material.dart';

class Errordatos extends StatelessWidget {
  const Errordatos({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Mira bien lo que estas haciendo (ERROR!)',
          style: TextStyle(color: Colors.redAccent)),
    );
  }
}
