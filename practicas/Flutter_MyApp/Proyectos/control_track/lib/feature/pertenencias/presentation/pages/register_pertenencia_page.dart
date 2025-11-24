import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pertenencia_model.dart';
import '../../../movimientos/presentation/pages/scan_serial_page.dart';
import '../../../../shared/widgets/animated_gradient_background.dart';
import '../../../auth/domain/services/auth_service.dart';

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

  @override
  void dispose() {
    _descripcionController.dispose();
    _serialController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _placaController.dispose();
    _tipoVehiculoController.dispose();
    super.dispose();
  }

  String _getTipoLabel(PertenenciaTipo tipo) {
    switch (tipo) {
      case PertenenciaTipo.equipo:
        return 'Equipo';
      case PertenenciaTipo.herramienta:
        return 'Herramienta';
      case PertenenciaTipo.vehiculo:
        return 'Vehículo';
      case PertenenciaTipo.otro:
        return 'Otro';
    }
  }

  IconData _getTipoIcon(PertenenciaTipo tipo) {
    switch (tipo) {
      case PertenenciaTipo.equipo:
        return Icons.devices;
      case PertenenciaTipo.herramienta:
        return Icons.build;
      case PertenenciaTipo.vehiculo:
        return Icons.directions_car;
      case PertenenciaTipo.otro:
        return Icons.category;
    }
  }

  void _mostrarAlerta(String titulo, String mensaje, {bool esError = true}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: esError
                ? Colors.red.shade50
                : const Color(0xFF0A8754).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            esError ? Icons.warning_amber_rounded : Icons.check_circle,
            color: esError ? Colors.red.shade700 : const Color(0xFF0A8754),
            size: 40,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          mensaje,
          style: const TextStyle(fontFamily: 'Montserrat'),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A8754),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Entendido',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registrarPertenencia() async {
    // Validaciones
    if (_tipo == null) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor selecciona el tipo de pertenencia.',
      );
      return;
    }

    final descripcion = _descripcionController.text.trim();
    if (descripcion.isEmpty) {
      _mostrarAlerta('Campo requerido', 'Por favor ingresa una descripción.');
      return;
    }
    if (descripcion.length < 3) {
      _mostrarAlerta(
        'Descripción inválida',
        'La descripción debe tener al menos 3 caracteres.',
      );
      return;
    }

    // Validaciones específicas por tipo
    if (_tipo == PertenenciaTipo.equipo) {
      final serial = _serialController.text.trim();
      if (serial.isEmpty) {
        _mostrarAlerta(
          'Campo requerido',
          'Por favor ingresa el serial del equipo.',
        );
        return;
      }
    }

    if (_tipo == PertenenciaTipo.vehiculo) {
      final placa = _placaController.text.trim();
      final tipoVehiculo = _tipoVehiculoController.text.trim();

      if (placa.isEmpty) {
        _mostrarAlerta(
          'Campo requerido',
          'Por favor ingresa la placa del vehículo.',
        );
        return;
      }
      if (placa.length < 5 || placa.length > 7) {
        _mostrarAlerta(
          'Placa inválida',
          'La placa debe tener entre 5 y 7 caracteres.',
        );
        return;
      }
      if (tipoVehiculo.isEmpty) {
        _mostrarAlerta(
          'Campo requerido',
          'Por favor especifica el tipo de vehículo.',
        );
        return;
      }
    }

    if (_tipo == PertenenciaTipo.equipo ||
        _tipo == PertenenciaTipo.herramienta ||
        _tipo == PertenenciaTipo.vehiculo ||
        _tipo == PertenenciaTipo.otro) {
      final marca = _marcaController.text.trim();
      if (marca.isEmpty) {
        _mostrarAlerta('Campo requerido', 'Por favor ingresa la marca.');
        return;
      }
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      // Obtener el email del usuario actual para auditoría
      final authService = AuthService();
      final currentUserEmail = authService.getCurrentUserEmail();

      final pertenencia = Pertenencia(
        id: '',
        usuarioId: widget.usuarioId,
        tipo: _tipo!,
        descripcion: descripcion,
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
        creadoPor: currentUserEmail,
      );

      await FirebaseFirestore.instance
          .collection('pertenencias')
          .add(pertenencia.toMap());

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A8754).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF0A8754),
                size: 48,
              ),
            ),
            title: const Text(
              '¡Éxito!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Pertenencia "$descripcion" registrada correctamente.',
              style: const TextStyle(fontFamily: 'Montserrat'),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A8754),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Error: ${e.toString()}');
        _mostrarAlerta(
          'Error al registrar',
          'Ocurrió un error:\\n${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Registrar pertenencia',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Hero(
                      tag: 'logo_sena',
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/logo_sena.png',
                            fit: BoxFit.contain,
                            height: 54,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.inventory_2,
                              size: 54,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Nueva pertenencia',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Registra equipos, herramientas o vehículos',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF0A8754).withOpacity(0.10),
                          width: 1.5,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<PertenenciaTipo>(
                              value: _tipo,
                              decoration: InputDecoration(
                                labelText: 'Tipo de pertenencia',
                                prefixIcon: Icon(
                                  _tipo != null
                                      ? _getTipoIcon(_tipo!)
                                      : Icons.category_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              dropdownColor: Colors.white,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              items: PertenenciaTipo.values.map((tipo) {
                                return DropdownMenuItem(
                                  value: tipo,
                                  child: Text(_getTipoLabel(tipo)),
                                );
                              }).toList(),
                              onChanged: (tipo) => setState(() => _tipo = tipo),
                              validator: (v) =>
                                  v == null ? 'Seleccione un tipo' : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _descripcionController,
                              style: const TextStyle(fontFamily: 'Montserrat'),
                              decoration: InputDecoration(
                                labelText: 'Descripción',
                                prefixIcon: const Icon(
                                  Icons.description_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                hintText: 'Ej: Laptop Dell Inspiron 15',
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo requerido'
                                  : null,
                              maxLines: 2,
                            ),
                            if (_tipo == PertenenciaTipo.equipo) ...[
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _serialController,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Serial',
                                        prefixIcon: const Icon(Icons.qr_code_2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        hintText: 'Ej: ABC123456',
                                      ),
                                      validator: (v) => v == null || v.isEmpty
                                          ? 'Campo requerido'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A8754),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.white,
                                      ),
                                      tooltip: 'Escanear serial',
                                      onPressed: () async {
                                        final code = await Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const ScanSerialPage(),
                                              ),
                                            );
                                        if (code != null && code is String) {
                                          setState(() {
                                            _serialController.text = code;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Serial escaneado: $code',
                                              ),
                                              backgroundColor: const Color(
                                                0xFF0A8754,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_tipo == PertenenciaTipo.equipo ||
                                _tipo == PertenenciaTipo.herramienta ||
                                _tipo == PertenenciaTipo.vehiculo ||
                                _tipo == PertenenciaTipo.otro) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _marcaController,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Marca',
                                  prefixIcon: const Icon(
                                    Icons.branding_watermark,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  hintText: 'Ej: Dell, HP, Toyota',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                              ),
                            ],
                            if (_tipo == PertenenciaTipo.equipo ||
                                _tipo == PertenenciaTipo.herramienta ||
                                _tipo == PertenenciaTipo.vehiculo) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _modeloController,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Modelo (opcional)',
                                  prefixIcon: const Icon(Icons.model_training),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  hintText: 'Ej: Inspiron 15, Corolla 2020',
                                ),
                              ),
                            ],
                            if (_tipo == PertenenciaTipo.vehiculo) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _placaController,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Placa',
                                  prefixIcon: const Icon(Icons.pin),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  hintText: 'Ej: ABC123',
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return 'Campo requerido';
                                  if (v.length < 5 || v.length > 7) {
                                    return 'La placa debe tener entre 5 y 7 caracteres';
                                  }
                                  return null;
                                },
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _tipoVehiculoController,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Tipo de vehículo',
                                  prefixIcon: const Icon(
                                    Icons.directions_car_outlined,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  hintText:
                                      'Ej: Automóvil, Motocicleta, Bicicleta',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                              ),
                            ],
                            const SizedBox(height: 22),
                            if (_error.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 12.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _error,
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_loading)
                              const Center(child: CircularProgressIndicator())
                            else
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.add_circle_outline),
                                  label: const Text('Registrar pertenencia'),
                                  onPressed: _registrarPertenencia,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A8754),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
