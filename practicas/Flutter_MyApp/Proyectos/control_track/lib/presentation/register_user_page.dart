import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _otroTipoController = TextEditingController();
  UserRole? _rol;
  String _error = '';
  bool _loading = false;

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate() || _rol == null) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final user = AppUser(
        id: '',
        nombre: _nombreController.text.trim(),
        cedula: _cedulaController.text.trim(),
        celular: _celularController.text.trim(),
        correo: _correoController.text.trim(),
        rol: _rol!,
        otroTipo: _rol == UserRole.otro
            ? _otroTipoController.text.trim()
            : null,
      );
      await FirebaseFirestore.instance.collection('usuarios').add(user.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado correctamente.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al registrar: $e';
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
      appBar: AppBar(title: const Text('Registrar usuario')),
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
                  onPressed: _registrarUsuario,
                  child: const Text('Registrar usuario'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
