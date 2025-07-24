import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:zona44_app/services/api_service.dart';
import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';

class ProductsAdminScreen extends StatefulWidget {
  final Group group;
  const ProductsAdminScreen({super.key, required this.group});

  @override
  State<ProductsAdminScreen> createState() => _ProductsAdminScreenState();
}

class _ProductsAdminScreenState extends State<ProductsAdminScreen> {
  final ApiService _api = ApiService();

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

  Future<void> _loadProducts() async {
    final items = await _api.getProductsByGroup(widget.group.id.toString());
    setState(() => _products = items);
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

  Future<void> _crearProducto() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (name.isEmpty || desc.isEmpty || price <= 0) return;

    bool ok = false;
    if (kIsWeb && _webImageBytes != null && _webImageName != null) {
      ok = await _api.createProductWeb(
        name, desc, price, widget.group.id, _webImageBytes!, _webImageName!
      );
    } else if (!kIsWeb && _image != null) {
      ok = await _api.createProductMobile(
        name, desc, price, widget.group.id, _image!
      );
    }

    if (ok) {
      _clearForm();
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto creado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear producto')));
    }
  }

  Future<void> _editarProducto(Product prod) async {
    _nameController.text = prod.name;
    _descController.text = prod.description;
    _priceController.text = prod.price.toString();
    _image = null;
    _webImageBytes = null;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar producto'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: _descController, decoration: InputDecoration(labelText: 'Descripción')),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              kIsWeb
                ? (_webImageBytes != null
                  ? Image.memory(_webImageBytes!, height: 80)
                  : (prod.imageUrl != null
                    ? Image.network(prod.imageUrl!, height:80)
                    : Text('Sin imagen')))
                : (_image != null
                  ? Image.file(_image!, height: 80)
                  : (prod.imageUrl != null
                    ? Image.network(prod.imageUrl!, height:80)
                    : Text('Sin imagen'))),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Cambiar imagen'),
                onPressed: _pickImage,
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(onPressed: () async {
            final name = _nameController.text.trim();
            final desc = _descController.text.trim();
            final price = int.tryParse(_priceController.text.trim()) ?? 0;
            bool ok = false;
            if (kIsWeb) {
              ok = await _api.updateProductWeb(
                id: prod.id,
                name: name,
                description: desc,
                price: price,
                imageBytes: _webImageBytes,
                imageName: _webImageName
              );
            } else {
              ok = await _api.updateProductMobile(
                id: prod.id,
                name: name,
                description: desc,
                price: price,
                imageFile: _image
              );
            }

            if (ok) {
              Navigator.pop(context);
              _clearForm();
              _loadProducts();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto actualizado')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar')));
            }
          }, child: Text('Guardar')),
        ],
      )
    );
  }

  Future<void> _borrarProducto(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar producto'),
        content: Text('¿Confirmas eliminar el producto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
        ],
      ),
    );
    if (confirm == true) {
      final ok = await _api.deleteProduct(id);
      if (ok) {
        _loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto eliminado')));
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    setState(() {
      _image = null;
      _webImageBytes = null;
      _webImageName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos - ${widget.group.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: 'Descripción')),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            kIsWeb
              ? (_webImageBytes != null 
                ? Image.memory(_webImageBytes!, height: 100) 
                : Text('No se ha seleccionado imagen'))
              : (_image != null 
                ? Image.file(_image!, height: 100) 
                : Text('No se ha seleccionado imagen')),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Seleccionar imagen'),
            ),
            ElevatedButton(
              onPressed: _crearProducto,
              child: Text('Crear producto'),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (_, i) {
                  final prod = _products[i];
                  return ListTile(
                    leading: prod.imageUrl != null
                      ? Image.network(prod.imageUrl!, width: 50)
                      : Icon(Icons.fastfood),
                    title: Text(prod.name),
                    subtitle: Text('${prod.description} - \$${prod.price}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v=='edit') _editarProducto(prod);
                        if (v=='delete') _borrarProducto(prod.id);
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
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
