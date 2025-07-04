import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../data/models/pertenencia_model.dart';
import 'register_pertenencia_page.dart';
import 'edit_user_page.dart';
import 'edit_pertenencia_page.dart';
import 'registrar_movimiento_page.dart';
import '_pertenencia_filter_section.dart';

class UserDetailPage extends StatelessWidget {
  final AppUser user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(title: Text('Usuario: ${updatedUser.nombre}')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cédula: ${updatedUser.cedula}'),
                    Text('Celular: ${updatedUser.celular}'),
                    Text('Correo: ${updatedUser.correo}'),
                    Text(
                      'Tipo: '
                      '${updatedUser.rol == UserRole.instructorPlanta
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
                          : 'Otro'}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RegisterPertenenciaPage(
                                  usuarioId: updatedUser.id,
                                ),
                              ),
                            );
                          },
                          child: const Text('Registrar pertenencia'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Eliminar usuario'),
                                content: const Text(
                                  '¿Estás seguro de eliminar este usuario? Esta acción no se puede deshacer.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('usuarios')
                                  .doc(updatedUser.id)
                                  .delete();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Eliminar usuario'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditUserPage(user: updatedUser),
                          ),
                        );
                      },
                      child: const Text('Editar usuario'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Pertenencias registradas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: PertenenciaFilterSection(userId: updatedUser.id)),
            ],
          ),
        );
      },
    );
  }

  // Agregar función auxiliar para mostrar solo los campos relevantes
  Widget _buildPertenenciaSubtitle(Pertenencia p) {
    List<String> parts = [];
    if (p.marca != null && p.marca!.isNotEmpty) {
      parts.add('Marca: ${p.marca}');
    }
    if (p.tipo == PertenenciaTipo.equipo &&
        p.serial != null &&
        p.serial!.isNotEmpty) {
      parts.add('Serial: ${p.serial}');
    }
    if (p.tipo == PertenenciaTipo.vehiculo &&
        p.placa != null &&
        p.placa!.isNotEmpty) {
      parts.add('Placa: ${p.placa}');
    }
    return Text(parts.isEmpty ? '-' : parts.join(' | '));
  }
}
