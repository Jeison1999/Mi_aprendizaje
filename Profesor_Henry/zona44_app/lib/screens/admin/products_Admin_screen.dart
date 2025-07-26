import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
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
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;
  Uint8List? _webImageBytes;
  String? _webImageName;
  final _apiService = ApiService();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await _apiService.getProductsByGroup(widget.group.id);
    setState(() {
      _products = products;
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

  void _crearProducto() async {
    final nombre = _nameController.text.trim();
    final desc = _descController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    bool exito = false;
    if (nombre.isEmpty || desc.isEmpty || price <= 0) return;
    if (kIsWeb) {
      if (_webImageBytes == null || _webImageName == null) return;
      exito = await _apiService.createProductWeb(
        nombre,
        desc,
        price,
        widget.group.id,
        _webImageBytes!,
        _webImageName!,
      );
    } else {
      if (_image == null) return;
      exito = await _apiService.createProductWithImage(
        nombre,
        desc,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Producto creado correctamente')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear producto')));
    }
  }

  void _eliminarProducto(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar este producto?'),
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
      final success = await _apiService.deleteProduct(id);
      if (success) {
        _loadProducts();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Producto eliminado')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar producto')));
      }
    }
  }

  void _mostrarEditarDialog(Product product) {
    final editNameController = TextEditingController(text: product.name);
    final editDescController = TextEditingController(text: product.description);
    final editPriceController = TextEditingController(
      text: product.price.toString(),
    );
    File? editImage;
    Uint8List? editWebImageBytes;
    String? editWebImageName;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('Editar producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: editNameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: editDescController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: editPriceController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                kIsWeb
                    ? (editWebImageBytes != null
                          ? Image.memory(editWebImageBytes!, height: 80)
                          : (product.imageUrl != null
                                ? Image.network(product.imageUrl!, height: 80)
                                : Text('Sin imagen')))
                    : (editImage != null
                          ? Image.file(editImage!, height: 80)
                          : (product.imageUrl != null
                                ? Image.network(product.imageUrl!, height: 80)
                                : Text('Sin imagen'))),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Cambiar imagen'),
                  onPressed: () async {
                    if (kIsWeb) {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null && result.files.single.bytes != null) {
                        setStateDialog(() {
                          editWebImageBytes = result.files.single.bytes;
                          editWebImageName = result.files.single.name;
                        });
                      }
                    } else {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          editImage = File(picked.path);
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final nuevoNombre = editNameController.text;
                final nuevaDesc = editDescController.text;
                final nuevoPrecio =
                    double.tryParse(editPriceController.text) ?? 0;
                bool success = false;
                if (nuevoNombre.isNotEmpty &&
                    nuevaDesc.isNotEmpty &&
                    nuevoPrecio > 0) {
                  if (kIsWeb &&
                      editWebImageBytes != null &&
                      editWebImageName != null) {
                    success = await _apiService.updateProductWeb(
                      id: product.id,
                      name: nuevoNombre,
                      description: nuevaDesc,
                      price: nuevoPrecio.toInt(),
                      groupId: widget.group.id,
                      imageBytes: editWebImageBytes,
                      imageName: editWebImageName,
                    );
                  } else if (!kIsWeb && editImage != null) {
                    success = await _apiService.updateProductMobile(
                      id: product.id,
                      name: nuevoNombre,
                      description: nuevaDesc,
                      price: nuevoPrecio.toInt(),
                      groupId: widget.group.id,
                      imageFile: editImage,
                    );
                  } else {
                    success = await _apiService.updateProduct(
                      product.id,
                      nuevoNombre,
                      nuevaDesc,
                      nuevoPrecio,
                      widget.group.id,
                    );
                  }
                  if (success) {
                    _loadProducts();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Producto actualizado')),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos de ${widget.group.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre del producto'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _crearProducto,
              child: const Text('Crear producto'),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      product.description +
                          ' - Precio: ' +
                          product.price.toString(),
                    ),
                    leading: product.imageUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(product.imageUrl!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.image_not_supported),
                          ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _mostrarEditarDialog(product);
                        } else if (value == 'delete') {
                          _eliminarProducto(product.id);
                        }
                      },
                      itemBuilder: (context) => const [
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
