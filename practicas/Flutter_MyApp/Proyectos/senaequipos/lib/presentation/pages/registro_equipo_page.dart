import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/value_objects/nombre_completo.dart';
import '../../domain/value_objects/cedula.dart';
import '../../domain/value_objects/serial_equipo.dart';
import '../../domain/value_objects/caracteristica.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../domain/value_objects/hora_registro.dart';
import '../../application/use_cases/crear_registro_equipo.dart';

class RegistroEquipoPage extends StatefulWidget {
  const RegistroEquipoPage({super.key});

  @override
  State<RegistroEquipoPage> createState() => _RegistroEquipoPageState();
}

class _RegistroEquipoPageState extends State<RegistroEquipoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _serialController = TextEditingController();
  final _caracteristicaController = TextEditingController();
  bool _guardando = false;
  String? _mensaje;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _serialController.dispose();
    _caracteristicaController.dispose();
    super.dispose();
  }

  Future<void> _guardarRegistro() async {
    setState(() {
      _guardando = true;
      _mensaje = null;
    });
    try {
      final registro = RegistroEquipo(
        nombre: NombreCompleto(_nombreController.text),
        cedula: Cedula(_cedulaController.text),
        serial: SerialEquipo(_serialController.text),
        caracteristica: Caracteristica(_caracteristicaController.text),
        horaEntrada: HoraRegistro(),
      );
      await GetIt.I<CrearRegistroEquipo>().call(registro);
      setState(() {
        _mensaje = 'Registro guardado correctamente';
      });
      _formKey.currentState?.reset();
    } catch (e) {
      setState(() {
        _mensaje = e.toString();
      });
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) {
                  try {
                    NombreCompleto(value ?? '');
                  } catch (e) {
                    return e.toString();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula o Tarjeta de Identidad',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  try {
                    Cedula(value ?? '');
                  } catch (e) {
                    return e.toString();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serialController,
                decoration: const InputDecoration(
                  labelText: 'Serial del equipo',
                ),
                validator: (value) {
                  try {
                    SerialEquipo(value ?? '');
                  } catch (e) {
                    return e.toString();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caracteristicaController,
                decoration: const InputDecoration(
                  labelText: 'Característica (marca o color)',
                ),
                validator: (value) {
                  try {
                    Caracteristica(value ?? '');
                  } catch (e) {
                    return e.toString();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_mensaje != null)
                Text(
                  _mensaje!,
                  style: TextStyle(
                    color: _mensaje!.contains('correctamente')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ElevatedButton(
                onPressed: _guardando
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _guardarRegistro();
                        }
                      },
                child: _guardando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
