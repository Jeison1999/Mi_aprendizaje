import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        _mensaje = 'Registro guardado correctamente';
      });
      _formKey.currentState?.reset();
      _nombreEncontrado = null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
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
      builder: (context) => _BarcodeScannerDialog(),
    );
    if (serial != null && serial.isNotEmpty) {
      setState(() {
        _serialController.text = serial;
      });
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF39A900)),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Registrar Equipo',
          style: TextStyle(
            color: Color(0xFF39A900),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Fondo degradado y burbujas decorativas
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
            child: _Bubble(color: Colors.white.withOpacity(0.08), size: 180),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: _Bubble(color: Colors.white.withOpacity(0.10), size: 120),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width > 400 ? 80 : 24,
                  vertical: 24,
                ),
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 38,
                            color: Color(0xFF39A900),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Registrar Equipo',
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF222222),
                                ) ??
                                const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cedulaController,
                              decoration: const InputDecoration(
                                labelText: 'Cédula del aprendiz',
                                prefixIcon: Icon(Icons.badge_rounded),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (_) {
                                _nombreEncontrado = null;
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: _buscando
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.search_rounded),
                                label: Text(
                                  _buscando ? 'Buscando...' : 'Buscar aprendiz',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[700],
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: _buscando
                                    ? null
                                    : _buscarAprendizPorCedula,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_nombreEncontrado != null)
                              Text(
                                'Aprendiz encontrado: $_nombreEncontrado',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (_nombreEncontrado == null)
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
                              controller: _serialController,
                              decoration: InputDecoration(
                                labelText: 'Serial del equipo',
                                prefixIcon: const Icon(
                                  Icons.confirmation_number_rounded,
                                ),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.qr_code_scanner_rounded,
                                  ),
                                  tooltip: 'Escanear codigo',
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
                                            'Conecte un lector de código de barras USB o escriba el serial.',
                                          ),
                                          backgroundColor: Colors.blueGrey,
                                        ),
                                      );
                                    }
                                  },
                                ),
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
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _caracteristicaController,
                              decoration: const InputDecoration(
                                labelText: 'Característica (marca o color)',
                                prefixIcon: Icon(Icons.info_outline_rounded),
                                border: OutlineInputBorder(),
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
                                  _guardando ? 'Guardando...' : 'Guardar',
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
                                onPressed: _guardando
                                    ? null
                                    : () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _guardarRegistro();
                                        }
                                      },
                              ),
                            ),
                          ],
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

class _Bubble extends StatelessWidget {
  final Color color;
  final double size;
  const _Bubble({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _BarcodeScannerDialog extends StatefulWidget {
  @override
  State<_BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<_BarcodeScannerDialog> {
  bool _found = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: SizedBox(
        width: 320,
        height: 420,
        child: Stack(
          children: [
            MobileScanner(
              onDetect: (capture) {
                if (_found) return;
                final barcode = capture.barcodes.firstOrNull;
                if (barcode != null && barcode.rawValue != null) {
                  _found = true;
                  Navigator.of(context).pop(barcode.rawValue);
                }
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Escanea el codigo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
