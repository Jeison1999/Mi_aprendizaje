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
import '../widgets/barcode_scanner_dialog.dart';
import '../widgets/bubble.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/serial_text_form_field.dart';
import '../widgets/primary_button.dart';

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
      builder: (context) => const BarcodeScannerDialog(),
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
        title: SizedBox(
          height: 44,
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
                            CustomTextFormField(
                              controller: _cedulaController,
                              label: 'Cédula del aprendiz',
                              icon: Icons.badge_rounded,
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
                              CustomTextFormField(
                                controller: _nombreController,
                                label: 'Nombre completo',
                                icon: Icons.person_rounded,
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
                            SerialTextFormField(
                              controller: _serialController,
                              label: 'Serial del equipo',
                              validator: (value) {
                                try {
                                  SerialEquipo(value ?? '');
                                } catch (e) {
                                  return e.toString();
                                }
                                return null;
                              },
                              onScan: () async {
                                if (Theme.of(context).platform ==
                                        TargetPlatform.android ||
                                    Theme.of(context).platform ==
                                        TargetPlatform.iOS) {
                                  await _escanearSerialMobileScanner();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Conecte un lector de código de barras USB o escriba el serial.',
                                      ),
                                      backgroundColor: Colors.blueGrey,
                                    ),
                                  );
                                }
                                return null;
                              },
                              context: context,
                            ),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: _caracteristicaController,
                              label: 'Característica (marca o color)',
                              icon: Icons.info_outline_rounded,
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
                            PrimaryButton(
                              label: _guardando ? 'Guardando...' : 'Guardar',
                              icon: Icons.save_rounded,
                              loading: _guardando,
                              onPressed: _guardando
                                  ? null
                                  : () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _guardarRegistro();
                                      }
                                    },
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
