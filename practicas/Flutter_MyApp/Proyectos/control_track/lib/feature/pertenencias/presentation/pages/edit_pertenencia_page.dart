import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/pertenencia_model.dart';
import '../../../../shared/widgets/animated_gradient_background.dart';
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
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          mensaje,
          style: GoogleFonts.montserrat(),
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
              child: Text(
                'Entendido',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editarPertenencia() async {
    // Validaciones
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

    setState(() {
      _loading = true;
    });

    try {
      final authService = AuthService();
      final currentUserEmail = authService.getCurrentUserEmail();

      await FirebaseFirestore.instance
          .collection('pertenencias')
          .doc(widget.pertenencia.id)
          .update({
            'tipo': _tipo.name,
            'descripcion': descripcion,
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
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A8754).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF0A8754),
                size: 40,
              ),
            ),
            title: Text(
              '¡Actualización exitosa!',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Los datos de la pertenencia han sido actualizados correctamente.',
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A8754),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
      });
      if (mounted) {
        _mostrarAlerta(
          'Error',
          'Hubo un problema al actualizar la pertenencia. Intenta nuevamente.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
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
        title: Text(
          'Editar Pertenencia',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Actualiza los datos de la pertenencia',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Tipo de pertenencia
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getTipoIcon(_tipo),
                                  color: const Color(0xFF0A8754),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tipo de pertenencia',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0A8754),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: PertenenciaTipo.values.map((tipo) {
                                final isSelected = _tipo == tipo;
                                return InkWell(
                                  onTap: () => setState(() => _tipo = tipo),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF0A8754)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF0A8754)
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getTipoIcon(tipo),
                                          size: 18,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _getTipoLabel(tipo),
                                          style: GoogleFonts.montserrat(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Descripción
                      _buildCard(
                        child: _buildTextField(
                          controller: _descripcionController,
                          label: 'Descripción',
                          hint: 'Ej: Laptop Dell Latitude',
                          icon: Icons.description,
                          required: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campos específicos por tipo
                      if (_tipo == PertenenciaTipo.equipo) ...[
                        _buildCard(
                          child: _buildTextField(
                            controller: _serialController,
                            label: 'Serial',
                            hint: 'Ej: ABC123XYZ',
                            icon: Icons.confirmation_number,
                            required: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_tipo == PertenenciaTipo.equipo ||
                          _tipo == PertenenciaTipo.herramienta ||
                          _tipo == PertenenciaTipo.vehiculo ||
                          _tipo == PertenenciaTipo.otro) ...[
                        _buildCard(
                          child: _buildTextField(
                            controller: _marcaController,
                            label: 'Marca',
                            hint: 'Ej: Dell, HP, Toyota',
                            icon: Icons.business,
                            required: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_tipo == PertenenciaTipo.equipo ||
                          _tipo == PertenenciaTipo.herramienta ||
                          _tipo == PertenenciaTipo.vehiculo) ...[
                        _buildCard(
                          child: _buildTextField(
                            controller: _modeloController,
                            label: 'Modelo (opcional)',
                            hint: 'Ej: Latitude 5420',
                            icon: Icons.info_outline,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_tipo == PertenenciaTipo.vehiculo) ...[
                        _buildCard(
                          child: _buildTextField(
                            controller: _placaController,
                            label: 'Placa',
                            hint: 'Ej: ABC123',
                            icon: Icons.local_shipping,
                            required: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          child: _buildTextField(
                            controller: _tipoVehiculoController,
                            label: 'Tipo de vehículo',
                            hint: 'Ej: Automóvil, Camioneta, Moto',
                            icon: Icons.directions_car,
                            required: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 8),
                      // Botón guardar
                      _loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _editarPertenencia,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0A8754),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.save, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Guardar Cambios',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(height: 32),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0A8754), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A8754),
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          style: GoogleFonts.montserrat(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0A8754), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
