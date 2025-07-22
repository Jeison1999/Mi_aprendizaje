import 'package:flutter/material.dart';
import 'package:zona44_app/services/api_service.dart';

class GroupsAdminScreen extends StatefulWidget {
  const GroupsAdminScreen({super.key});

  @override
  State<GroupsAdminScreen> createState() => _GroupsAdminScreenState();
}

class _GroupsAdminScreenState extends State<GroupsAdminScreen> {
  final _controller = TextEditingController();
  final _apiService = ApiService();

  void _crearGrupo() async {
    final nombre = _controller.text;
    if (nombre.isEmpty) return;

    final exito = await _apiService.createGroup(nombre);
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo creado correctamente')),
      );
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear grupo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administrar Grupos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre del grupo'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _crearGrupo,
              child: Text('Crear grupo'),
            ),
          ],
        ),
      ),
    );
  }
}
