import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _error = '';
  bool _loading = false;
  bool _rememberWithBiometric = false;
  bool _canUseBiometric = false;
  String? _lastUserEmail;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadLastUser();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final canUse = await _authService.canAuthenticateWithBiometrics();
    if (!mounted) return;

    final isEnabled = await _authService.isBiometricEnabled();
    if (!mounted) return;

    print('🔐 Biometric check: canUse=$canUse, isEnabled=$isEnabled');

    setState(() {
      _canUseBiometric = canUse;
      _rememberWithBiometric = isEnabled;
    });
  }

  Future<void> _loadLastUser() async {
    final email = await _authService.getLastUserEmail();
    if (email != null && mounted) {
      setState(() {
        _lastUserEmail = email;
        _emailController.text = email;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final authenticated = await _authService.authenticateWithBiometrics();
      if (!mounted) return;

      if (!authenticated) {
        setState(() {
          _error = 'Autenticación biométrica cancelada';
          _loading = false;
        });
        return;
      }

      final credentials = await _authService.getStoredCredentials();
      if (!mounted) return;

      if (credentials == null) {
        setState(() {
          _error = 'No hay credenciales guardadas';
          _loading = false;
        });
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: credentials['email']!,
        password: credentials['password']!,
      );

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message ?? 'Error desconocido';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error en autenticación biométrica';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('🔑 Login: email=$email, remember=$_rememberWithBiometric');

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Por favor ingresa email y contraseña';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      // Si el usuario quiere recordar con huella, PRIMERO pedimos la huella
      // Esto evita que el AuthGate redirija antes de tiempo y asegura la autorización
      if (_rememberWithBiometric) {
        final authenticated = await _authService.authenticateWithBiometrics();
        if (!mounted) return;

        if (!authenticated) {
          setState(() {
            _error =
                'Autenticación biométrica cancelada. No se puede activar el ingreso con huella.';
            _loading = false;
          });
          return;
        }
      }

      // Si pasó la huella (o no la pidió), intentamos el login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Login exitoso');

      // Si llegamos aquí y _rememberWithBiometric es true, es seguro guardar
      // porque ya pasó la verificación biométrica arriba
      if (_rememberWithBiometric) {
        print('💾 Guardando credenciales...');
        await _authService.saveCredentials(email, password, true);
        print('✅ Credenciales guardadas');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Huella registrada exitosamente'),
              backgroundColor: Color(0xFF0A8754),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        await _authService.clearCredentials();
        print('🗑️ Credenciales limpiadas');
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message ?? 'Error desconocido';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fondo degradado animado
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFF0A8754),
                        const Color(0xFF00C897),
                        value,
                      )!,
                      Color.lerp(
                        const Color(0xFF00C897),
                        const Color(0xFF0A8754),
                        value,
                      )!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Hero(
                            tag: 'logo_sena',
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/logo_sena.png',
                                  fit: BoxFit.contain,
                                  height: 70,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.account_circle,
                                        size: 70,
                                        color: Colors.green[700],
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) => Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 30),
                                child: child,
                              ),
                            ),
                            child: Text(
                              'Control Track SENA',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1800),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) => Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 20),
                                child: child,
                              ),
                            ),
                            child: Text(
                              'Acceso seguro a tus pertenencias',
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (_lastUserEmail != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Último usuario: $_lastUserEmail',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: Center(
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08,
                                ),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Botón de login biométrico
                                      if (_canUseBiometric &&
                                          _rememberWithBiometric)
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF0A8754,
                                                ).withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.fingerprint,
                                                  size: 48,
                                                  color: Color(0xFF0A8754),
                                                ),
                                                onPressed: _loading
                                                    ? null
                                                    : _loginWithBiometric,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Toca para iniciar con huella',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  child: Text(
                                                    'o ingresa con email',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      TextField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Correo institucional',
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                          ),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: _passwordController,
                                        decoration: const InputDecoration(
                                          labelText: 'Contraseña',
                                          prefixIcon: Icon(Icons.lock_outline),
                                        ),
                                        obscureText: true,
                                        onSubmitted: (_) => _login(),
                                      ),
                                      if (_canUseBiometric)
                                        CheckboxListTile(
                                          title: Text(
                                            'Recordar con huella digital',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                            ),
                                          ),
                                          value: _rememberWithBiometric,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberWithBiometric =
                                                  value ?? false;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      const SizedBox(height: 24),
                                      if (_error.isNotEmpty)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                        const CircularProgressIndicator()
                                      else
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.login),
                                            label: const Text('Ingresar'),
                                            onPressed: _login,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF0A8754,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              textStyle: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
