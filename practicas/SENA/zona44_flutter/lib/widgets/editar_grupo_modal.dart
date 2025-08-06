import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

import '../config/api_config.dart';

class EditarGrupoModal extends StatefulWidget {
  final Map grupo;
  final VoidCallback onGrupoActualizado;

  const EditarGrupoModal({
    required this.grupo,
    required this.onGrupoActualizado,
    super.key,
  });

  @override
  _EditarGrupoModalState createState() => _EditarGrupoModalState();
}

class _EditarGrupoModalState extends State<EditarGrupoModal> {
  late TextEditingController nombreController;
  File? imagenSeleccionada;
  Uint8List? imagenWeb;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.grupo['nombre']);
  }

  Future<void> seleccionarImagen() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          imagenWeb = bytes;
        });
      } else {
        setState(() {
          imagenSeleccionada = File(picked.path);
        });
      }
    }
  }

  Future<void> actualizarGrupo() async {
    if (nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("El nombre no puede estar vacío")));
      return;
    }

    setState(() => cargando = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final uri = Uri.parse('$apiUrl/api/grupos/${widget.grupo['id']}');

      final request = http.MultipartRequest("PATCH", uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['nombre'] = nombreController.text.trim();

      if (kIsWeb && imagenWeb != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'imagen',
          imagenWeb!,
          filename: 'imagen.png',
          contentType: MediaType('image', 'png'),
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && imagenSeleccionada != null) {
        final mimeType =
            lookupMimeType(imagenSeleccionada!.path) ?? 'image/jpeg';
        final file = await http.MultipartFile.fromPath(
          'imagen',
          imagenSeleccionada!.path,
          contentType: MediaType.parse(mimeType),
          filename: path.basename(imagenSeleccionada!.path),
        );
        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context);
        widget.onGrupoActualizado();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al actualizar grupo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ocurrió un error: $e")));
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Editar grupo"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre del grupo"),
            ),
            SizedBox(height: 10),
            if (kIsWeb && imagenWeb != null)
              Image.memory(imagenWeb!, height: 100)
            else if (!kIsWeb && imagenSeleccionada != null)
              Image.file(imagenSeleccionada!, height: 100)
            else if (widget.grupo['imagen_url'] != null)
              Image.network(widget.grupo['imagen_url'], height: 100),
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
          onPressed: cargando ? null : actualizarGrupo,
          child: cargando
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text("Actualizar"),
        ),
      ],
    );
  }
}
