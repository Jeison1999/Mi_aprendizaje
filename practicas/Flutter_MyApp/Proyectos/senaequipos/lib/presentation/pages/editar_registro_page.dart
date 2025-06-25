import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../domain/value_objects/caracteristica.dart';
import '../../domain/value_objects/hora_registro.dart';
import '../../domain/value_objects/nombre_completo.dart';
import '../../application/use_cases/actualizar_registro_equipo.dart';

class EditarRegistroPage extends StatefulWidget {
  final RegistroEquipo registro;
  const EditarRegistroPage({super.key, required this.registro});

  @override
  State<EditarRegistroPage> createState() => _EditarRegistroPageState();
}

class _EditarRegistroPageState extends State<EditarRegistroPage> {
  late TextEditingController _nombreController;
  late TextEditingController _caracteristicaController;
  DateTime? _horaEntrada;
  DateTime? _horaSalida;
  bool _guardando = false;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.registro.nombre.value,
    );
    _caracteristicaController = TextEditingController(
      text: widget.registro.caracteristica.value,
    );
    _horaEntrada = widget.registro.horaEntrada.value;
    _horaSalida = widget.registro.horaSalida?.value;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _caracteristicaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() {
      _guardando = true;
      _mensaje = null;
    });
    try {
      final actualizado = RegistroEquipo(
        nombre: NombreCompleto(_nombreController.text),
        cedula: widget.registro.cedula,
        serial: widget.registro.serial,
        caracteristica: Caracteristica(_caracteristicaController.text),
        horaEntrada: _horaEntrada != null
            ? HoraRegistro(_horaEntrada!)
            : widget.registro.horaEntrada,
        horaSalida: _horaSalida != null ? HoraRegistro(_horaSalida!) : null,
      );
      await GetIt.I<ActualizarRegistroEquipo>().call(actualizado);
      setState(() {
        _mensaje = 'Registro actualizado correctamente';
      });
      Navigator.pop(context, true);
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
      appBar: AppBar(title: const Text('Editar Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Serial: ${widget.registro.serial.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _caracteristicaController,
              decoration: const InputDecoration(
                labelText: 'Característica (marca o color)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Hora de entrada:'),
                const SizedBox(width: 8),
                Text(
                  _horaEntrada != null
                      ? '${_horaEntrada!.hour.toString().padLeft(2, '0')}:${_horaEntrada!.minute.toString().padLeft(2, '0')}'
                      : 'No registrada',
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_horaEntrada ?? now),
                    );
                    if (picked != null) {
                      setState(() {
                        _horaEntrada = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Hora de salida:'),
                const SizedBox(width: 8),
                Text(
                  _horaSalida != null
                      ? '${_horaSalida!.hour.toString().padLeft(2, '0')}:${_horaSalida!.minute.toString().padLeft(2, '0')}'
                      : 'No registrada',
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_horaSalida ?? now),
                    );
                    if (picked != null) {
                      setState(() {
                        _horaSalida = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                ),
              ],
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
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
