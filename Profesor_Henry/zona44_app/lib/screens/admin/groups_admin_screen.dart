import 'package:flutter/material.dart';
import 'package:zona44_app/services/api_service.dart';
import 'package:zona44_app/models/group.dart';

class GroupsAdminScreen extends StatefulWidget {
  const GroupsAdminScreen({super.key});

  @override
  State<GroupsAdminScreen> createState() => _GroupsAdminScreenState();
}

class _GroupsAdminScreenState extends State<GroupsAdminScreen> {
  final _controller = TextEditingController();
  final _apiService = ApiService();

  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() async {
    final groups = await _apiService.fetchGroups();
    setState(() {
      _groups = groups;
    });
  }

  void _crearGrupo() async {
    final nombre = _controller.text;
    if (nombre.isEmpty) return;

    final exito = await _apiService.createGroup(nombre);
    if (exito) {
      _controller.clear();
      _loadGroups();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo creado correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear grupo')),
      );
    }
  }

  void _eliminarGrupo(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar este grupo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _apiService.deleteGroup(id);
      if (success) {
        _loadGroups();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar grupo')),
        );
      }
    }
  }

  void _mostrarEditarDialog(Group group) {
    final editController = TextEditingController(text: group.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar grupo'),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(labelText: 'Nombre del grupo'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final nuevoNombre = editController.text;
              if (nuevoNombre.isNotEmpty) {
                final success = await _apiService.updateGroup(group.id, nuevoNombre);
                if (success) {
                  _loadGroups();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Grupo actualizado')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar')),
                  );
                }
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
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
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return ListTile(
                    title: Text(group.name),
                    leading: CircleAvatar(child: Text(group.id.toString())),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _mostrarEditarDialog(group);
                        } else if (value == 'delete') {
                          _eliminarGrupo(group.id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
