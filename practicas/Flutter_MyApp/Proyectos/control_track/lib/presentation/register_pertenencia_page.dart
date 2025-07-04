import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/pertenencia_model.dart';
import 'scan_serial_page.dart';

class RegisterPertenenciaPage extends StatefulWidget {
  final String usuarioId;
  const RegisterPertenenciaPage({super.key, required this.usuarioId});

  @override
  State<RegisterPertenenciaPage> createState() =>
      _RegisterPertenenciaPageState();
}

class _RegisterPertenenciaPageState extends State<RegisterPertenenciaPage> {
  final _formKey = GlobalKey<FormState>();
  PertenenciaTipo? _tipo;
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _tipoVehiculoController = TextEditingController();
  String _error = '';
  bool _loading = false;

  Future<void> _registrarPertenencia() async {
    if (!_formKey.currentState!.validate() || _tipo == null) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final pertenencia = Pertenencia(
        id: '',
        usuarioId: widget.usuarioId,
        tipo: _tipo!,
        descripcion: _descripcionController.text.trim(),
        serial: _tipo == PertenenciaTipo.equipo
            ? _serialController.text.trim()
            : null,
        marca:
            (_tipo == PertenenciaTipo.equipo ||
                _tipo == PertenenciaTipo.herramienta ||
                _tipo == PertenenciaTipo.vehiculo ||
                _tipo == PertenenciaTipo.otro)
            ? _marcaController.text.trim()
            : null,
        modelo:
            (_tipo == PertenenciaTipo.equipo ||
                _tipo == PertenenciaTipo.herramienta ||
                _tipo == PertenenciaTipo.vehiculo)
            ? _modeloController.text.trim()
            : null,
        placa: _tipo == PertenenciaTipo.vehiculo
            ? _placaController.text.trim()
            : null,
        tipoVehiculo: _tipo == PertenenciaTipo.vehiculo
            ? _tipoVehiculoController.text.trim()
            : null,
        fechaRegistro: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection('pertenencias')
          .add(pertenencia.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pertenencia registrada correctamente.'),
          ),
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
      appBar: AppBar(title: const Text('Registrar pertenencia')),
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
                onChanged: (tipo) => setState(() => _tipo = tipo),
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
              if (_tipo == PertenenciaTipo.equipo) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _serialController,
                        decoration: const InputDecoration(labelText: 'Serial'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Campo requerido' : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: 'Escanear serial',
                      onPressed: () async {
                        final code = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ScanSerialPage(),
                          ),
                        );
                        if (code != null && code is String) {
                          setState(() {
                            _serialController.text = code;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Serial escaneado: $code')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
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
                  onPressed: _registrarPertenencia,
                  child: const Text('Registrar pertenencia'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
