import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

// Animaciones reutilizables (copiadas de home_page.dart para independencia visual)

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({Key? key}) : super(key: key);
  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFF0A8754),
                  const Color(0xFF00C897),
                  _animation.value,
                )!,
                Color.lerp(
                  const Color(0xFF00C897),
                  const Color(0xFF0A8754),
                  _animation.value,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

class AnimatedEntrance extends StatelessWidget {
  final Widget child;
  final int delay;
  const AnimatedEntrance({required this.child, this.delay = 0, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        final show = snapshot.connectionState == ConnectionState.done;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: show ? 1 : 0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 30),
              child: child,
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _otroTipoController = TextEditingController();
  UserRole? _rol;
  String _error = '';
  bool _loading = false;
  bool _showPassword = false;

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate() || _rol == null) return;
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
          const SnackBar(content: Text('Usuario registrado correctamente.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Error al registrar: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
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
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
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
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
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
                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                                  );
                                  if (!emailRegex.hasMatch(v))
                                    return 'Correo inválido';
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    _error,
                                    style: const TextStyle(color: Colors.red),
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
