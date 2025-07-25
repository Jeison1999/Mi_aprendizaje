import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona44_app/models/pizza_base.dart';
import 'package:zona44_app/services/api_service.dart';

class PizzaFormScreen extends StatefulWidget {
  final PizzaBase? pizza;

  const PizzaFormScreen({super.key, this.pizza});

  @override
  State<PizzaFormScreen> createState() => _PizzaFormScreenState();
}

class _PizzaFormScreenState extends State<PizzaFormScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'tradicional';

  File? _image;
  Uint8List? _webImageBytes;
  String? _webImageName;

  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.pizza != null) {
      _nameController.text = widget.pizza!.name;
      _descController.text = widget.pizza!.description;
      _category = widget.pizza!.category;
    }
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
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _image = File(picked.path));
      }
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();

    if (name.isEmpty || desc.isEmpty) return;

    final isEdit = widget.pizza != null;

    bool ok = false;

    if (kIsWeb) {
      if (_webImageBytes != null && _webImageName != null) {
        ok = isEdit
            ? await _api.updatePizzaWeb(
                id: widget.pizza!.id!,
                name: name,
                description: desc,
                category: _category,
                imageBytes: _webImageBytes!,
                imageName: _webImageName!,
              )
            : await _api.createPizzaWeb(
                name: name,
                description: desc,
                category: _category,
                imageBytes: _webImageBytes!,
                imageName: _webImageName!,
              );
      } else if (isEdit) {
        // Editar solo texto, sin imagen
        ok = await _api.updatePizzaWeb(
          id: widget.pizza!.id!,
          name: name,
          description: desc,
          category: _category,
          imageBytes: null,
          imageName: null,
        );
      }
    } else {
      if (_image != null) {
        ok = isEdit
            ? await _api.updatePizza(
                id: widget.pizza!.id!,
                name: name,
                description: desc,
                category: _category,
                imageFile: _image!,
              )
            : await _api.createPizzaMobile(
                name: name,
                description: desc,
                category: _category,
                imageFile: _image!,
              );
      } else if (isEdit) {
        // Editar solo texto, sin imagen
        ok = await _api.updatePizza(
          id: widget.pizza!.id!,
          name: name,
          description: desc,
          category: _category,
          imageFile: null,
        );
      }
    }

    if (ok) {
      Navigator.pop(context, true); // volvemos a pantalla anterior
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al guardar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.pizza != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar pizza' : 'Crear pizza')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              DropdownButtonFormField(
                value: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: const [
                  DropdownMenuItem(
                    value: 'tradicional',
                    child: Text('Tradicional'),
                  ),
                  DropdownMenuItem(value: 'especial', child: Text('Especial')),
                  DropdownMenuItem(
                    value: 'combinada',
                    child: Text('Combinada'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value.toString();
                  });
                },
              ),
              const SizedBox(height: 10),
              kIsWeb
                  ? (_webImageBytes != null
                        ? Image.memory(_webImageBytes!, height: 80)
                        : (widget.pizza?.imageUrl != null
                              ? Image.network(
                                  widget.pizza!.imageUrl!,
                                  height: 80,
                                )
                              : const Text('Sin imagen')))
                  : (_image != null
                        ? Image.file(_image!, height: 80)
                        : (widget.pizza?.imageUrl != null
                              ? Image.network(
                                  widget.pizza!.imageUrl!,
                                  height: 80,
                                )
                              : const Text('Sin imagen'))),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar imagen'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEdit ? 'Guardar cambios' : 'Crear pizza'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
