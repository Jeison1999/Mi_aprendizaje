import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class EditarProductoModal extends StatefulWidget {
  final Map producto;
  final VoidCallback onProductoEditado;

  const EditarProductoModal({
    super.key,
    required this.producto,
    required this.onProductoEditado,
  });

  @override
  State<EditarProductoModal> createState() => _EditarProductoModalState();
}

class _EditarProductoModalState extends State<EditarProductoModal> {
  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;

  File? imagenSeleccionada;
  Uint8List? imagenWeb;
  String? imagenNombre;
  int? grupoSeleccionado;
  List grupos = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.producto['nombre']);
    descripcionController = TextEditingController(
      text: widget.producto['descripcion'] ?? '',
    );
    precioController = TextEditingController(
      text: widget.producto['precio'].toString(),
    );
    grupoSeleccionado = widget.producto['grupo_id'];
    cargarGrupos();
  }

  Future<void> cargarGrupos() async {
    final response = await http.get(Uri.parse('$apiUrl/api/grupos'));
    if (response.statusCode == 200) {
      setState(() {
        grupos = List.from(jsonDecode(response.body));
      });
    }
  }

  Future<void> seleccionarImagen() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          imagenWeb = bytes;
          imagenNombre = picked.name;
        });
      } else {
        setState(() {
          imagenSeleccionada = File(picked.path);
          imagenNombre = picked.name;
        });
      }
    }
  }

  Future<void> actualizarProducto() async {
    if (nombreController.text.isEmpty ||
        precioController.text.isEmpty ||
        grupoSeleccionado == null)
      return;

    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse('$apiUrl/api/productos/${widget.producto['id']}');
    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nombre'] = nombreController.text;
    request.fields['descripcion'] = descripcionController.text;
    request.fields['precio'] = precioController.text;
    request.fields['grupo_id'] = grupoSeleccionado.toString();

    if (imagenWeb != null) {
      final mimeType =
          lookupMimeType(imagenNombre ?? 'file.jpg', headerBytes: imagenWeb!) ??
          'image/jpeg';
      request.files.add(
        http.MultipartFile.fromBytes(
          'imagen',
          imagenWeb!,
          filename: imagenNombre ?? 'imagen.jpg',
          contentType: MediaType.parse(mimeType),
        ),
      );
    } else if (imagenSeleccionada != null) {
      final mimeType = lookupMimeType(imagenSeleccionada!.path) ?? 'image/jpeg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'imagen',
          imagenSeleccionada!.path,
          contentType: MediaType.parse(mimeType),
          filename: path.basename(imagenSeleccionada!.path),
        ),
      );
    }

    final response = await request.send();

    setState(() => cargando = false);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      widget.onProductoEditado();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al actualizar producto")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Editar producto"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Precio"),
            ),
            DropdownButtonFormField(
              value: grupoSeleccionado,
              items: grupos.map<DropdownMenuItem<int>>((g) {
                return DropdownMenuItem<int>(
                  value: g['id'],
                  child: Text(g['nombre']),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => grupoSeleccionado = val as int),
              decoration: InputDecoration(labelText: "Grupo"),
            ),
            SizedBox(height: 10),
            if (imagenSeleccionada != null && !kIsWeb)
              Image.file(imagenSeleccionada!, height: 100),
            if (imagenWeb != null && kIsWeb)
              Image.memory(imagenWeb!, height: 100),
            if (imagenSeleccionada == null && imagenWeb == null)
              widget.producto['imagen_url'] != null
                  ? Image.network(widget.producto['imagen_url'], height: 100)
                  : Text("No se ha seleccionado imagen"),
            TextButton(
              onPressed: seleccionarImagen,
              child: Text("Cambiar imagen"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: cargando ? null : actualizarProducto,
          child: cargando ? CircularProgressIndicator() : Text("Guardar"),
        ),
      ],
    );
  }
}
