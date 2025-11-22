import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

import '../../../pertenencias/presentation/pages/register_pertenencia_page.dart';
import 'edit_user_page.dart';
import '../../../pertenencias/presentation/widgets/_pertenencia_filter_section.dart';

// Animaciones reutilizables (copiadas de register_user_page.dart para independencia visual)
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});
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
  const AnimatedEntrance({required this.child, this.delay = 0, super.key});

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

class UserDetailPage extends StatelessWidget {
  final AppUser user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Usuario no encontrado.')),
          );
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final updatedUser = AppUser.fromMap(userData, user.id);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Detalle usuario',
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Hero(
                        tag: 'logo_sena',
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 54,
                            color: Color(0xFF0A8754),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedEntrance(
                        delay: 100,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 22,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF0A8754).withOpacity(0.13),
                              width: 1.7,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                updatedUser.nombre,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF0A8754),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0A8754,
                                  ).withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  updatedUser.rol == UserRole.instructorPlanta
                                      ? 'Instructor de planta'
                                      : updatedUser.rol == UserRole.instructorContratista
                                      ? 'Instructor contratista'
                                      : updatedUser.rol == UserRole.aprendiz
                                      ? 'Aprendiz'
                                      : updatedUser.rol == UserRole.administrativo
                                      ? 'Administrativo'
                                      : updatedUser.rol == UserRole.teo
                                      ? 'TEO'
                                      : updatedUser.rol == UserRole.visitante
                                      ? 'Visitante'
                                      : updatedUser.rol == UserRole.otro && updatedUser.otroTipo != null
                                      ? 'Otro (${updatedUser.otroTipo})'
                                      : 'Otro',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF0A8754),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _InfoTile(
                                    icon: Icons.badge_outlined,
                                    label: 'Cédula',
                                    value: updatedUser.cedula,
                                  ),
                                  _InfoTile(
                                    icon: Icons.phone_outlined,
                                    label: 'Celular',
                                    value: updatedUser.celular,
                                  ),
                                  _InfoTile(
                                    icon: Icons.email_outlined,
                                    label: 'Correo',
                                    value: updatedUser.correo,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth > 500;
                                  return isWide
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _FancyActionButton(
                                              icon: Icons.add_box_rounded,
                                              label: 'Registrar pertenencia',
                                              color: const Color(0xFF0A8754),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        RegisterPertenenciaPage(
                                                          usuarioId:
                                                              updatedUser.id,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 18),
                                            _FancyActionButton(
                                              icon: Icons.edit_rounded,
                                              label: 'Editar',
                                              color: Colors.orange,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        EditUserPage(
                                                          user: updatedUser,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 12),
                                            _FancyActionButton(
                                              icon:
                                                  Icons.delete_forever_rounded,
                                              label: 'Eliminar',
                                              color: Colors.red[700]!,
                                              onTap: () async {
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: const Text(
                                                      'Eliminar usuario',
                                                    ),
                                                    content: const Text(
                                                      '¿Estás seguro de eliminar este usuario? Esta acción no se puede deshacer.',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              ctx,
                                                              false,
                                                            ),
                                                        child: const Text(
                                                          'Cancelar',
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              ctx,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'Eliminar',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('usuarios')
                                                      .doc(updatedUser.id)
                                                      .delete();
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _FancyActionButton(
                                              icon: Icons.add_box_rounded,
                                              label: 'Registrar pertenencia',
                                              color: const Color(0xFF0A8754),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        RegisterPertenenciaPage(
                                                          usuarioId:
                                                              updatedUser.id,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _FancyActionButton(
                                                    icon: Icons.edit_rounded,
                                                    label: 'Editar',
                                                    color: Colors.orange,
                                                    onTap: () {
                                                      Navigator.of(
                                                        context,
                                                      ).push(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              EditUserPage(
                                                                user:
                                                                    updatedUser,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _FancyActionButton(
                                                    icon: Icons
                                                        .delete_forever_rounded,
                                                    label: 'Eliminar',
                                                    color: Colors.red[700]!,
                                                    onTap: () async {
                                                      final confirm = await showDialog<bool>(
                                                        context: context,
                                                        builder: (ctx) => AlertDialog(
                                                          title: const Text(
                                                            'Eliminar usuario',
                                                          ),
                                                          content: const Text(
                                                            '¿Estás seguro de eliminar este usuario? Esta acción no se puede deshacer.',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    ctx,
                                                                    false,
                                                                  ),
                                                              child: const Text(
                                                                'Cancelar',
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    ctx,
                                                                    true,
                                                                  ),
                                                              child: const Text(
                                                                'Eliminar',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      if (confirm == true) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                              'usuarios',
                                                            )
                                                            .doc(updatedUser.id)
                                                            .delete();
                                                        if (context.mounted) {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      AnimatedEntrance(
                        delay: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.38,
                              child: PertenenciaFilterSection(
                                userId: updatedUser.id,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget para mostrar info de usuario con icono
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF0A8754).withOpacity(0.13),
            child: Icon(icon, color: const Color(0xFF0A8754)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Botón de acción mejorado y visualmente atractivo
class _FancyActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _FancyActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Gradientes institucionales para cada acción
    LinearGradient gradient;
    if (icon == Icons.add_box_rounded) {
      gradient = const LinearGradient(
        colors: [Color(0xFF0A8754), Color(0xFF00C897)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (icon == Icons.edit_rounded) {
      gradient = const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (icon == Icons.delete_forever_rounded) {
      gradient = const LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      gradient = LinearGradient(
        colors: [color, color.withOpacity(0.95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return Material(
      color: Colors.transparent,
      elevation: 6,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15.5,
                    letterSpacing: 0.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
