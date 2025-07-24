import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zona44_app/screens/admin/products_Admin_screen.dart';
import 'package:zona44_app/services/api_service.dart';
import 'package:zona44_app/models/group.dart';

class GroupsAdminScreen extends StatefulWidget {
  const GroupsAdminScreen({super.key});

  @override
  State<GroupsAdminScreen> createState() => _GroupsAdminScreenState();
}

class _GroupsAdminScreenState extends State<GroupsAdminScreen> {
  final _controller = TextEditingController();
  // Para web, guardamos la ruta y bytes; para móvil, solo File
  File? _image;
  Uint8List? _webImageBytes;
  String? _webImageName;
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

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageBytes = result.files.single.bytes;
          _webImageName = result.files.single.name;
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  void _crearGrupo() async {
    final nombre = _controller.text.trim();
    bool exito = false;
    if (nombre.isEmpty) return;

    if (kIsWeb) {
      if (_webImageBytes == null || _webImageName == null) return;
      exito = await _apiService.createGroupWithImageWeb(
        nombre,
        _webImageBytes!,
        _webImageName!,
      );
    } else {
      if (_image == null) return;
      exito = await _apiService.createGroupWithImage(nombre, _image!);
    }

    if (exito) {
      _controller.clear();
      setState(() {
        _image = null;
        _webImageBytes = null;
        _webImageName = null;
      });
      _loadGroups();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Grupo creado correctamente')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear grupo')));
    }
  }

  void _eliminarGrupo(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar este grupo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _apiService.deleteGroup(id);
      if (success) {
        _loadGroups();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Grupo eliminado')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar grupo')));
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nuevoNombre = editController.text;
              if (nuevoNombre.isNotEmpty) {
                final success = await _apiService.updateGroup(
                  group.id,
                  nuevoNombre,
                );
                if (success) {
                  _loadGroups();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Grupo actualizado')));
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
            const SizedBox(height: 10),
            kIsWeb
                ? (_webImageBytes != null
                      ? Image.memory(_webImageBytes!, height: 100)
                      : const Text('No se ha seleccionado imagen'))
                : (_image != null
                      ? Image.file(_image!, height: 100)
                      : const Text('No se ha seleccionado imagen')),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Seleccionar imagen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _crearGrupo,
              child: const Text('Crear grupo'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return ListTile(
                    title: Text(group.name),
                    leading: group.imageUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(group.imageUrl!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image_not_supported),
                          ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _mostrarEditarDialog(group);
                        } else if (value == 'delete') {
                          _eliminarGrupo(group.id);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductsAdminScreen(group: group),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
