import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';
import '../../../../shared/widgets/animated_gradient_background.dart';
import '../../../../shared/widgets/animated_entrance.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _celularController = TextEditingController();
  final _correoController = TextEditingController();
  final _otroTipoController = TextEditingController();

  UserRole? _rol;
  String _error = '';
  bool _loading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _celularController.dispose();
    _correoController.dispose();
    _otroTipoController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate() || _rol == null) {
      if (_rol == null) {
        setState(() => _error = 'Por favor selecciona un tipo de usuario');
      }
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final user = AppUser(
        id: '',
        nombre: _nombreController.text.trim(),
        cedula: _cedulaController.text.trim(),
        celular: _celularController.text.trim(),
        correo: _correoController.text.trim(),
        rol: _rol!,
        otroTipo: _rol == UserRole.otro
            ? _otroTipoController.text.trim()
            : null,
      );

      await FirebaseFirestore.instance.collection('usuarios').add(user.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Usuario registrado exitosamente'),
            backgroundColor: Color(0xFF0A8754),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Error al registrar: ${e.toString()}');
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
        title: Text(
          'Registrar usuario',
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
          // Fondo degradado institucional animado
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
                    Text(
                      'Nuevo usuario',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa los datos para registrar un usuario',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AnimatedEntrance(
                      delay: 200,
                      child: Container(
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
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
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
                              TextFormField(
                                controller: _cedulaController,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Cédula',
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
                                    return 'Cédula debe tener entre 6 y 12 dígitos';
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
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
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
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
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
                                decoration: InputDecoration(
                                  labelText: 'Tipo de usuario',
                                  prefixIcon: const Icon(Icons.group_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                validator: (v) =>
                                    v == null ? 'Seleccione un tipo' : null,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                                borderRadius: BorderRadius.circular(14),
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
                                      prefixIcon: const Icon(
                                        Icons.edit_outlined,
                                      ),
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
                                    label: const Text('Registrar usuario'),
                                    onPressed: _registrarUsuario,
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
