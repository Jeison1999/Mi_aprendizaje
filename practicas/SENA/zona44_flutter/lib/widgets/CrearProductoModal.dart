import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../config/api_config.dart';

class CrearProductoModal extends StatefulWidget {
  final VoidCallback onProductoCreado;

  const CrearProductoModal({super.key, required this.onProductoCreado});

  @override
  _CrearProductoModalState createState() => _CrearProductoModalState();
}

class _CrearProductoModalState extends State<CrearProductoModal> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();

  File? imagenSeleccionada;
  int? grupoSeleccionado;
  List grupos = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();
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
      setState(() => imagenSeleccionada = File(picked.path));
    }
  }

  Future<void> crearProducto() async {
    if (nombreController.text.isEmpty ||
        precioController.text.isEmpty ||
        grupoSeleccionado == null ||
        imagenSeleccionada == null) {
      return;
    }

    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final uri = Uri.parse('$apiUrl/api/productos');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nombre'] = nombreController.text;
    request.fields['descripcion'] = descripcionController.text;
    request.fields['precio'] = precioController.text;
    request.fields['grupo_id'] = grupoSeleccionado.toString();

    final mimeType = lookupMimeType(imagenSeleccionada!.path)!;
    final file = await http.MultipartFile.fromPath(
      'imagen',
      imagenSeleccionada!.path,
      contentType: MediaType.parse(mimeType),
      filename: path.basename(imagenSeleccionada!.path),
    );

    request.files.add(file);
    final response = await request.send();

    setState(() => cargando = false);

    if (response.statusCode == 201) {
      Navigator.pop(context);
      widget.onProductoCreado();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear producto")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Crear nuevo producto"),
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
              onChanged: (val) => setState(() => grupoSeleccionado = val as int),
              decoration: InputDecoration(labelText: "Grupo"),
            ),
            SizedBox(height: 10),
            imagenSeleccionada != null
                ? Image.file(imagenSeleccionada!, height: 100)
                : Text("No se ha seleccionado imagen"),
            TextButton(
              onPressed: seleccionarImagen,
              child: Text("Seleccionar imagen"),
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
          onPressed: cargando ? null : crearProducto,
          child: cargando ? CircularProgressIndicator() : Text("Crear"),
        ),
      ],
    );
  }
}
