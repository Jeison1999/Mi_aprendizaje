import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../domain/value_objects/caracteristica.dart';
import '../../domain/value_objects/hora_registro.dart';
import '../../domain/value_objects/nombre_completo.dart';
import '../../application/use_cases/actualizar_registro_equipo.dart';
import '../widgets/barcode_scanner_dialog.dart';
import '../widgets/bubble.dart';

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

  Future<void> _escanearSerialMobileScanner() async {
    final serial = await showDialog<String>(
      context: context,
      builder: (context) => const BarcodeScannerDialog(),
    );
    if (serial != null && serial.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Serial escaneado: $serial'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: SizedBox(
          height: 35,
          child: Image.asset(
            'assets/pripro.png',
            fit: BoxFit.contain,
            semanticLabel: 'Logo institucional',
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFFB6FFB0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: Bubble(color: Colors.white.withOpacity(0.08), size: 180),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: Bubble(color: Colors.white.withOpacity(0.10), size: 120),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width > 400 ? 80 : 16,
                  vertical: 24,
                ),
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_rounded,
                            size: 34,
                            color: Color(0xFF39A900),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Editar Registro',
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : const Color(0xFF222222),
                                ) ??
                                const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Serial: ${widget.registro.serial.value}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.qr_code_scanner_rounded,
                                    ),
                                    tooltip: 'Escanear código',
                                    onPressed: () async {
                                      if (Theme.of(context).platform ==
                                              TargetPlatform.android ||
                                          Theme.of(context).platform ==
                                              TargetPlatform.iOS) {
                                        await _escanearSerialMobileScanner();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Conecte un lector de código de barras USB o edite el serial desde la base de datos.',
                                            ),
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre completo',
                                  prefixIcon: Icon(Icons.person_rounded),
                                  border: OutlineInputBorder(),
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
                                controller: _caracteristicaController,
                                decoration: const InputDecoration(
                                  labelText: 'Característica (marca o color)',
                                  prefixIcon: Icon(Icons.info_outline_rounded),
                                  border: OutlineInputBorder(),
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
                                        initialTime: TimeOfDay.fromDateTime(
                                          _horaEntrada ?? now,
                                        ),
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
                                        initialTime: TimeOfDay.fromDateTime(
                                          _horaSalida ?? now,
                                        ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: _guardando
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save_rounded),
                                  label: Text(
                                    _guardando
                                        ? 'Guardando...'
                                        : 'Guardar cambios',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF39A900),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: _guardando ? null : _guardar,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
