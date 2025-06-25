import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/value_objects/nombre_completo.dart';
import '../../domain/value_objects/cedula.dart';
import '../../domain/value_objects/serial_equipo.dart';
import '../../domain/value_objects/caracteristica.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../domain/value_objects/hora_registro.dart';
import '../../application/use_cases/crear_registro_equipo.dart';
import '../../application/use_cases/buscar_registro_equipo.dart';

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
  String? _nombreEncontrado;
  bool _buscando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _serialController.dispose();
    _caracteristicaController.dispose();
    super.dispose();
  }

  Future<void> _buscarAprendizPorCedula() async {
    setState(() {
      _buscando = true;
      _nombreEncontrado = null;
    });
    try {
      final buscar = GetIt.I<BuscarRegistroEquipo>();
      final registro = await buscar.call(
        cedula: _cedulaController.text.trim(),
        serial: '', // Buscar solo por cédula
      );
      if (registro != null) {
        setState(() {
          _nombreEncontrado = registro.nombre.value;
          _nombreController.text = _nombreEncontrado!;
        });
      } else {
        setState(() {
          _nombreEncontrado = null;
          _nombreController.clear();
        });
      }
    } catch (_) {
      setState(() {
        _nombreEncontrado = null;
        _nombreController.clear();
      });
    } finally {
      setState(() {
        _buscando = false;
      });
    }
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
      _nombreEncontrado = null;
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
                controller: _cedulaController,
                decoration: const InputDecoration(
                  labelText: 'Cédula del aprendiz',
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  _nombreEncontrado = null;
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _buscando ? null : _buscarAprendizPorCedula,
                child: _buscando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Buscar aprendiz'),
              ),
              const SizedBox(height: 16),
              if (_nombreEncontrado != null)
                Text(
                  'Aprendiz encontrado: $_nombreEncontrado',
                  style: const TextStyle(color: Colors.green),
                ),
              if (_nombreEncontrado == null)
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                  validator: (value) {
                    try {
                      NombreCompleto(value ?? '');
                    } catch (e) {
                      return e.toString();
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
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
