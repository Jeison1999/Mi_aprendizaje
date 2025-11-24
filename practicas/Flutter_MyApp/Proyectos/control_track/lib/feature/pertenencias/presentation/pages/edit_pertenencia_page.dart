import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pertenencia_model.dart';
import '../../../auth/domain/services/auth_service.dart';

class EditPertenenciaPage extends StatefulWidget {
  final Pertenencia pertenencia;
  const EditPertenenciaPage({super.key, required this.pertenencia});

  @override
  State<EditPertenenciaPage> createState() => _EditPertenenciaPageState();
}

class _EditPertenenciaPageState extends State<EditPertenenciaPage> {
  final _formKey = GlobalKey<FormState>();
  late PertenenciaTipo _tipo;
  late TextEditingController _descripcionController;
  late TextEditingController _serialController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _placaController;
  late TextEditingController _tipoVehiculoController;
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tipo = widget.pertenencia.tipo;
    _descripcionController = TextEditingController(
      text: widget.pertenencia.descripcion,
    );
    _serialController = TextEditingController(
      text: widget.pertenencia.serial ?? '',
    );
    _marcaController = TextEditingController(
      text: widget.pertenencia.marca ?? '',
    );
    _modeloController = TextEditingController(
      text: widget.pertenencia.modelo ?? '',
    );
    _placaController = TextEditingController(
      text: widget.pertenencia.placa ?? '',
    );
    _tipoVehiculoController = TextEditingController(
      text: widget.pertenencia.tipoVehiculo ?? '',
    );
  }

  Future<void> _editarPertenencia() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      // Obtener el email del usuario actual para auditoría
      final authService = AuthService();
      final currentUserEmail = authService.getCurrentUserEmail();

      await FirebaseFirestore.instance
          .collection('pertenencias')
          .doc(widget.pertenencia.id)
          .update({
            'tipo': _tipo.name,
            'descripcion': _descripcionController.text.trim(),
            'serial': _tipo == PertenenciaTipo.equipo
                ? _serialController.text.trim()
                : null,
            'marca':
                (_tipo == PertenenciaTipo.equipo ||
                    _tipo == PertenenciaTipo.herramienta ||
                    _tipo == PertenenciaTipo.vehiculo ||
                    _tipo == PertenenciaTipo.otro)
                ? _marcaController.text.trim()
                : null,
            'modelo':
                (_tipo == PertenenciaTipo.equipo ||
                    _tipo == PertenenciaTipo.herramienta ||
                    _tipo == PertenenciaTipo.vehiculo)
                ? _modeloController.text.trim()
                : null,
            'placa': _tipo == PertenenciaTipo.vehiculo
                ? _placaController.text.trim()
                : null,
            'tipoVehiculo': _tipo == PertenenciaTipo.vehiculo
                ? _tipoVehiculoController.text.trim()
                : null,
            'modificadoPor': currentUserEmail,
            'fechaModificacion': DateTime.now().toIso8601String(),
          });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertenencia actualizada.')),
        );
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
      appBar: AppBar(title: const Text('Editar pertenencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<PertenenciaTipo>(
                value: _tipo,
                items: PertenenciaTipo.values.map((tipo) {
                  return DropdownMenuItem(value: tipo, child: Text(tipo.name));
                }).toList(),
                onChanged: (tipo) => setState(() => _tipo = tipo!),
                decoration: const InputDecoration(
                  labelText: 'Tipo de pertenencia',
                ),
                validator: (v) => v == null ? 'Seleccione un tipo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              if (_tipo == PertenenciaTipo.equipo)
                TextFormField(
                  controller: _serialController,
                  decoration: const InputDecoration(labelText: 'Serial'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              if (_tipo == PertenenciaTipo.equipo ||
                  _tipo == PertenenciaTipo.herramienta ||
                  _tipo == PertenenciaTipo.vehiculo ||
                  _tipo == PertenenciaTipo.otro)
                TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              if (_tipo == PertenenciaTipo.equipo ||
                  _tipo == PertenenciaTipo.herramienta ||
                  _tipo == PertenenciaTipo.vehiculo)
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(
                    labelText: 'Modelo (opcional)',
                  ),
                ),
              if (_tipo == PertenenciaTipo.vehiculo)
                TextFormField(
                  controller: _placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),
              if (_tipo == PertenenciaTipo.vehiculo)
                TextFormField(
                  controller: _tipoVehiculoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de vehículo',
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
                  onPressed: _editarPertenencia,
                  child: const Text('Guardar cambios'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
