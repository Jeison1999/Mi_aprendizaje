import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Material App Bar')),
        body: const Center(child: Text('Hello World')),
      ),
    );
  }
}

class AgregarUsuarioDialog extends StatefulWidget {
  @override
  State<AgregarUsuarioDialog> createState() => _AgregarUsuarioDialogState();
}

class _AgregarUsuarioDialogState extends State<AgregarUsuarioDialog> {
  final _nombreController = TextEditingController();
  final _inicialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar usuario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: _inicialController,
            decoration: InputDecoration(labelText: 'Inicial'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final nombre = _nombreController.text.trim();
            final inicial = _inicialController.text.trim();
            if (nombre.isNotEmpty && inicial.isNotEmpty) {
              await FirebaseFirestore.instance.collection('usuarios').add({
                'nombre': nombre,
                'inicial': inicial,
              });
              Navigator.pop(context);
            }
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }
}
