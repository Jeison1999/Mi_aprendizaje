import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class EditUserPage extends StatefulWidget {
  final AppUser user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _cedulaController;
  late TextEditingController _celularController;
  late TextEditingController _correoController;
  late TextEditingController _otroTipoController;
  UserRole? _rol;
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.user.nombre);
    _cedulaController = TextEditingController(text: widget.user.cedula);
    _celularController = TextEditingController(text: widget.user.celular);
    _correoController = TextEditingController(text: widget.user.correo);
    _otroTipoController = TextEditingController(
      text: widget.user.otroTipo ?? '',
    );
    _rol = widget.user.rol;
  }

  Future<void> _editarUsuario() async {
    if (!_formKey.currentState!.validate() || _rol == null) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.user.id)
          .update({
            'nombre': _nombreController.text.trim(),
            'cedula': _cedulaController.text.trim(),
            'celular': _celularController.text.trim(),
            'correo': _correoController.text.trim(),
            'rol': _rol!.name,
            'otroTipo': _rol == UserRole.otro
                ? _otroTipoController.text.trim()
                : null,
          });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Usuario actualizado.')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al actualizar: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _celularController,
                decoration: const InputDecoration(labelText: 'Celular'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: _rol,
                items: UserRole.values.map((rol) {
                  return DropdownMenuItem(value: rol, child: Text(rol.name));
                }).toList(),
                onChanged: (rol) => setState(() => _rol = rol),
                decoration: const InputDecoration(labelText: 'Tipo de usuario'),
                validator: (v) => v == null ? 'Seleccione un tipo' : null,
              ),
              if (_rol == UserRole.otro)
                TextFormField(
                  controller: _otroTipoController,
                  decoration: const InputDecoration(
                    labelText: 'Especifique otro tipo',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              const SizedBox(height: 24),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _editarUsuario,
                  child: const Text('Guardar cambios'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
