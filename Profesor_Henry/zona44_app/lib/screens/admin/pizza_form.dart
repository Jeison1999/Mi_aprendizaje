import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona44_app/models/pizza_base.dart';
import 'package:zona44_app/services/api_service.dart';

class PizzaSizeInput {
  String size;
  String price;

  PizzaSizeInput({this.size = '', this.price = ''});
}

class PizzaFormScreen extends StatefulWidget {
  final PizzaBase? pizza;

  const PizzaFormScreen({super.key, this.pizza});

  @override
  State<PizzaFormScreen> createState() => _PizzaFormScreenState();
}

class _PizzaFormScreenState extends State<PizzaFormScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _cheesePriceController = TextEditingController();
  String _category = 'tradicional';

  File? _image;
  Uint8List? _webImageBytes;
  String? _webImageName;

  bool _hasCheeseBorder = false;

  final _api = ApiService();
  List<PizzaSizeInput> _sizes = [];

  @override
  void initState() {
    super.initState();

    if (widget.pizza != null) {
      final pizza = widget.pizza!;
      _nameController.text = pizza.name;
      _descController.text = pizza.description;
      _category = pizza.category;

      _hasCheeseBorder = pizza.hasCheeseBorder ?? false;
      _cheesePriceController.text = pizza.cheeseBorderPrice?.toString() ?? '';

      if (pizza.sizes != null) {
        _sizes = pizza.sizes!
            .map(
              (s) =>
                  PizzaSizeInput(size: s['size'], price: s['price'].toString()),
            )
            .toList();
      }
    }
  }

  void _addSize() {
    setState(() => _sizes.add(PizzaSizeInput()));
  }

  void _removeSize(int index) {
    setState(() => _sizes.removeAt(index));
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
    final cheesePrice = int.tryParse(_cheesePriceController.text.trim()) ?? 0;

    if (name.isEmpty || desc.isEmpty) return;

    final isEdit = widget.pizza != null;

    final pizzaVariantsAttributes = _sizes
        .where((s) => s.size.isNotEmpty && s.price.isNotEmpty)
        .map(
          (s) => {
            'size': s.size.trim().toLowerCase(),
            'price': int.tryParse(s.price) ?? 0,
          },
        )
        .toList();

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
                pizza_variants_attributes: pizzaVariantsAttributes,
                hasCheeseBorder: _hasCheeseBorder,
                cheeseBorderPrice: cheesePrice,
              )
            : await _api.createPizzaWebMultipart(
                name: name,
                description: desc,
                category: _category,
                imageBytes: _webImageBytes!,
                imageName: _webImageName!,
                pizza_variants_attributes: pizzaVariantsAttributes,
                hasCheeseBorder: _hasCheeseBorder,
                cheeseBorderPrice: cheesePrice,
              );
      } else if (isEdit) {
        ok = await _api.updatePizzaWeb(
          id: widget.pizza!.id!,
          name: name,
          description: desc,
          category: _category,
          imageBytes: null,
          imageName: null,
          pizza_variants_attributes: pizzaVariantsAttributes,
          hasCheeseBorder: _hasCheeseBorder,
          cheeseBorderPrice: cheesePrice,
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
                sizes: pizzaVariantsAttributes,
                hasCheeseBorder: _hasCheeseBorder,
                cheeseBorderPrice: cheesePrice,
              )
            : await _api.createPizzaMobile(
                name: name,
                description: desc,
                category: _category,
                imageFile: _image!,
                sizes: pizzaVariantsAttributes,
                hasCheeseBorder: _hasCheeseBorder,
                cheeseBorderPrice: cheesePrice,
              );
      } else if (isEdit) {
        ok = await _api.updatePizza(
          id: widget.pizza!.id!,
          name: name,
          description: desc,
          category: _category,
          imageFile: null,
          sizes: pizzaVariantsAttributes,
          hasCheeseBorder: _hasCheeseBorder,
          cheeseBorderPrice: cheesePrice,
        );
      }
    }

    if (ok) {
      Navigator.pop(context, true);
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
                onChanged: (value) =>
                    setState(() => _category = value.toString()),
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
              Row(
                children: [
                  Checkbox(
                    value: _hasCheeseBorder,
                    onChanged: (value) =>
                        setState(() => _hasCheeseBorder = value ?? false),
                  ),
                  const Text('¿Tiene borde de queso?'),
                ],
              ),
              TextField(
                controller: _cheesePriceController,
                decoration: const InputDecoration(
                  labelText: 'Precio del borde de queso',
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tamaños y precios',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _sizes.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Tamaño'),
                          onChanged: (value) => _sizes[index].size = value,
                          controller: TextEditingController(
                            text: _sizes[index].size,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Precio'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _sizes[index].price = value,
                          controller: TextEditingController(
                            text: _sizes[index].price,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSize(index),
                      ),
                    ],
                  );
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.add),
                label: Text('Agregar tamaño'),
                onPressed: _addSize,
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
