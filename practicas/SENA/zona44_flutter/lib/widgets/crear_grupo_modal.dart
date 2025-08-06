import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';

class CrearGrupoModal extends StatefulWidget {
  final VoidCallback onGrupoCreado;

  const CrearGrupoModal({super.key, required this.onGrupoCreado});

  @override
  _CrearGrupoModalState createState() => _CrearGrupoModalState();
}

class _CrearGrupoModalState extends State<CrearGrupoModal> {
  final nombreController = TextEditingController();
  XFile? imagenSeleccionada;
  Uint8List? imagenBytes;
  bool cargando = false;

  Future<void> crearGrupo() async {
    if (nombreController.text.isEmpty || imagenSeleccionada == null) return;

    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse('$apiUrl/api/grupos');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nombre'] = nombreController.text;

    // Debug prints para verificar token y headers
    print('Token usado: $token');
    print('Headers: \\${request.headers}');

    if (!kIsWeb) {
      final mimeType = lookupMimeType(imagenSeleccionada!.path)!;
      final file = await http.MultipartFile.fromPath(
        'imagen',
        imagenSeleccionada!.path,
        contentType: MediaType.parse(mimeType),
        filename: path.basename(imagenSeleccionada!.path),
      );
      request.files.add(file);
    } else {
      final mimeType = lookupMimeType(imagenSeleccionada!.name)!;
      final file = http.MultipartFile.fromBytes(
        'imagen',
        imagenBytes!,
        contentType: MediaType.parse(mimeType),
        filename: imagenSeleccionada!.name,
      );
      request.files.add(file);
    }

    final response = await request.send();

    setState(() => cargando = false);

    if (response.statusCode == 201) {
      Navigator.pop(context);
      widget.onGrupoCreado();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al crear grupo")));
    }
  }

  Future<void> seleccionarImagen() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagenSeleccionada = picked;
      });
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          imagenBytes = bytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget vistaPreviaImagen;
    if (imagenSeleccionada != null) {
      if (kIsWeb && imagenBytes != null) {
        vistaPreviaImagen = Image.memory(imagenBytes!, height: 100);
      } else {
        vistaPreviaImagen = Image.file(
          File(imagenSeleccionada!.path),
          height: 100,
        );
      }
    } else {
      vistaPreviaImagen = Text("Ninguna imagen seleccionada");
    }

    return AlertDialog(
      title: Text("Crear nuevo grupo"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreController,
            decoration: InputDecoration(labelText: "Nombre del grupo"),
          ),
          SizedBox(height: 10),
          vistaPreviaImagen,
          TextButton(
            onPressed: seleccionarImagen,
            child: Text("Seleccionar Imagen"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: cargando ? null : crearGrupo,
          child: cargando ? CircularProgressIndicator() : Text("Crear"),
        ),
      ],
    );
  }
}
