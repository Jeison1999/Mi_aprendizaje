import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';
import '../../../../shared/widgets/animated_gradient_background.dart';
import '../../../auth/domain/services/auth_service.dart';

class EditUserPage extends StatefulWidget {
  final AppUser user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _cedulaController;
  late TextEditingController _celularController;
  late TextEditingController _correoController;
  late TextEditingController _otroTipoController;

  late TipoDocumento _tipoDocumento;
  UserRole? _rol;
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.user.nombre);
    _cedulaController = TextEditingController(text: widget.user.cedula);
    _celularController = TextEditingController(text: widget.user.celular);
    _correoController = TextEditingController(text: widget.user.correo);
    _otroTipoController = TextEditingController(
      text: widget.user.otroTipo ?? '',
    );
    _tipoDocumento = widget.user.tipoDocumento;
    _rol = widget.user.rol;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _celularController.dispose();
    _correoController.dispose();
    _otroTipoController.dispose();
    super.dispose();
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

  Future<void> _editarUsuario() async {
    // Validaciones
    final nombre = _nombreController.text.trim();
    final cedula = _cedulaController.text.trim();
    final celular = _celularController.text.trim();
    final correo = _correoController.text.trim();

    if (nombre.isEmpty) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor ingresa el nombre completo.',
      );
      return;
    }
    if (nombre.length < 3) {
      _mostrarAlerta(
        'Nombre inválido',
        'El nombre debe tener al menos 3 caracteres.',
      );
      return;
    }

    if (cedula.isEmpty) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor ingresa el número de documento.',
      );
      return;
    }
    if (cedula.length < 6 || cedula.length > 12) {
      _mostrarAlerta(
        'Documento inválido',
        'El documento debe tener entre 6 y 12 dígitos.',
      );
      return;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cedula)) {
      _mostrarAlerta(
        'Documento inválido',
        'El documento solo puede contener números.',
      );
      return;
    }

    if (celular.isEmpty) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor ingresa el número de celular.',
      );
      return;
    }
    if (celular.length != 10) {
      _mostrarAlerta(
        'Celular inválido',
        'El número debe tener exactamente 10 dígitos.',
      );
      return;
    }
    if (!RegExp(r'^3[0-9]{9}$').hasMatch(celular)) {
      _mostrarAlerta(
        'Celular inválido',
        'Debe comenzar con 3 y tener formato colombiano.\\nEjemplo: 3001234567',
      );
      return;
    }

    if (correo.isEmpty) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor ingresa el correo electrónico.',
      );
      return;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(correo)) {
      _mostrarAlerta(
        'Correo inválido',
        'Ingresa un correo válido.\\nEjemplo: usuario@ejemplo.com',
      );
      return;
    }

    if (_rol == null) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor selecciona un tipo de usuario.',
      );
      return;
    }

    if (_rol == UserRole.otro && _otroTipoController.text.trim().isEmpty) {
      _mostrarAlerta(
        'Campo requerido',
        'Por favor especifica el tipo de usuario.',
      );
      return;
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

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.user.id)
          .update({
            'nombre': nombre,
            'tipoDocumento': _tipoDocumento.name,
            'cedula': cedula,
            'celular': celular,
            'correo': correo,
            'rol': _rol!.name,
            'otroTipo': _rol == UserRole.otro
                ? _otroTipoController.text.trim()
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
              'Usuario "$nombre" actualizado correctamente.',
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
          'Error al actualizar',
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
          'Editar usuario',
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
                              Icons.account_circle,
                              size: 54,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Editar usuario',
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
                      'Actualiza la información del usuario',
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
                            TextFormField(
                              controller: _nombreController,
                              style: const TextStyle(fontFamily: 'Montserrat'),
                              decoration: InputDecoration(
                                labelText: 'Nombre completo',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo requerido'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<TipoDocumento>(
                              value: _tipoDocumento,
                              decoration: InputDecoration(
                                labelText: 'Tipo de documento',
                                prefixIcon: const Icon(
                                  Icons.credit_card_outlined,
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
                              items: const [
                                DropdownMenuItem(
                                  value: TipoDocumento.ti,
                                  child: Text('TI - Tarjeta de Identidad'),
                                ),
                                DropdownMenuItem(
                                  value: TipoDocumento.cc,
                                  child: Text('CC - Cédula de Ciudadanía'),
                                ),
                                DropdownMenuItem(
                                  value: TipoDocumento.pasaporte,
                                  child: Text('Pasaporte'),
                                ),
                                DropdownMenuItem(
                                  value: TipoDocumento.cedulaExtranjera,
                                  child: Text('Cédula Extranjera'),
                                ),
                              ],
                              onChanged: (tipo) =>
                                  setState(() => _tipoDocumento = tipo!),
                              validator: (v) =>
                                  v == null ? 'Seleccione un tipo' : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _cedulaController,
                              style: const TextStyle(fontFamily: 'Montserrat'),
                              decoration: InputDecoration(
                                labelText: 'Número de documento',
                                prefixIcon: const Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                hintText: 'Ej: 1234567890',
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Campo requerido';
                                if (v.length < 6 || v.length > 12) {
                                  return 'Documento debe tener entre 6 y 12 dígitos';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                                  return 'Solo se permiten números';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _celularController,
                              style: const TextStyle(fontFamily: 'Montserrat'),
                              decoration: InputDecoration(
                                labelText: 'Celular',
                                prefixIcon: const Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                hintText: 'Ej: 3001234567',
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Campo requerido';
                                if (v.length != 10) {
                                  return 'El celular debe tener 10 dígitos';
                                }
                                if (!RegExp(r'^3[0-9]{9}$').hasMatch(v)) {
                                  return 'Número de celular inválido';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _correoController,
                              style: const TextStyle(fontFamily: 'Montserrat'),
                              decoration: InputDecoration(
                                labelText: 'Correo',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Campo requerido';
                                final emailRegex = RegExp(
                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                );
                                if (!emailRegex.hasMatch(v)) {
                                  return 'Ingresa un correo electrónico válido';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<UserRole>(
                              value: _rol,
                              decoration: InputDecoration(
                                labelText: 'Tipo de usuario',
                                prefixIcon: const Icon(Icons.group_outlined),
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
                              items: const [
                                DropdownMenuItem(
                                  value: UserRole.aprendiz,
                                  child: Text('Aprendiz'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.instructorPlanta,
                                  child: Text('Instructor de planta'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.instructorContratista,
                                  child: Text('Instructor contratista'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.administrativo,
                                  child: Text('Administrativo'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.teo,
                                  child: Text('TEO'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.visitante,
                                  child: Text('Visitante'),
                                ),
                                DropdownMenuItem(
                                  value: UserRole.otro,
                                  child: Text('Otro'),
                                ),
                              ],
                              onChanged: (rol) => setState(() => _rol = rol),
                              validator: (v) =>
                                  v == null ? 'Seleccione un tipo' : null,
                            ),
                            if (_rol == UserRole.otro)
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: TextFormField(
                                  controller: _otroTipoController,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Especifique otro tipo',
                                    prefixIcon: const Icon(Icons.edit_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Campo requerido'
                                      : null,
                                ),
                              ),
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
                                  icon: const Icon(Icons.save_alt_rounded),
                                  label: const Text('Guardar cambios'),
                                  onPressed: _editarUsuario,
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
