import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';
import 'package:zona44_app/services/api_service.dart';

class ProductsAdminScreen extends StatefulWidget {
  final Group group;
  const ProductsAdminScreen({super.key, required this.group});

  @override
  State<ProductsAdminScreen> createState() => _ProductsAdminScreenState();
}

class _ProductsAdminScreenState extends State<ProductsAdminScreen> {
  final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  File? _image;
  Uint8List? _webImageBytes;
  String? _webImageName;

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final productos = await _apiService.getProductsByGroup(widget.group.id.toString());
    setState(() {
      _products = productos;
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
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    }
  }

  void _crearProducto() async {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;

    bool exito = false;
    if (name.isEmpty || description.isEmpty || price <= 0) return;

    if (kIsWeb && _webImageBytes != null && _webImageName != null) {
      exito = await _apiService.createProductWeb(
        name,
        description,
        price,
        widget.group.id,
        _webImageBytes!,
        _webImageName!,
      );
    } else if (!kIsWeb && _image != null) {
      exito = await _apiService.createProductMobile(
        name,
        description,
        price,
        widget.group.id,
        _image!,
      );
    }

    if (exito) {
      _nameController.clear();
      _descController.clear();
      _priceController.clear();
      setState(() {
        _image = null;
        _webImageBytes = null;
        _webImageName = null;
      });
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto creado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear producto')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos - ${widget.group.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: 'Descripción')),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
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
            ElevatedButton(
              onPressed: _crearProducto,
              child: const Text('Crear producto'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (_, index) {
                  final product = _products[index];
                  return ListTile(
                    leading: product.imageUrl != null
                        ? Image.network(product.imageUrl!, width: 50)
                        : Icon(Icons.fastfood),
                    title: Text(product.name),
                    subtitle: Text('${product.description} - \$${product.price}'),
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
