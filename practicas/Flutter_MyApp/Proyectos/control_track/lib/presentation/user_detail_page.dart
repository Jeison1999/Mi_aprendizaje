import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../data/models/pertenencia_model.dart';
import 'register_pertenencia_page.dart';
import 'edit_user_page.dart';
import 'edit_pertenencia_page.dart';
import 'registrar_movimiento_page.dart';

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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pertenencias')
                      .where('usuarioId', isEqualTo: updatedUser.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Sin pertenencias registradas.'),
                      );
                    }
                    final pertenencias = snapshot.data!.docs
                        .map(
                          (doc) => Pertenencia.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ),
                        )
                        .toList();
                    return ListView.builder(
                      itemCount: pertenencias.length,
                      itemBuilder: (context, index) {
                        final p = pertenencias[index];
                        return ListTile(
                          title: Text(
                            '${p.tipo.name.toUpperCase()}: ${p.marca ?? ''}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.descripcion.isNotEmpty)
                                Text('Descripción: ${p.descripcion}'),
                              _buildPertenenciaSubtitle(p),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.green,
                                ),
                                tooltip: 'Registrar entrada/salida',
                                onPressed: () async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              RegistrarMovimientoPage(
                                                pertenencia: p,
                                                usuarioId: updatedUser.id,
                                              ),
                                        ),
                                      );
                                  if (result == true && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Movimiento registrado.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Editar pertenencia',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditPertenenciaPage(pertenencia: p),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                tooltip: 'Eliminar pertenencia',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Eliminar pertenencia'),
                                      content: const Text(
                                        '¿Estás seguro de eliminar esta pertenencia?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
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
                                        .collection('pertenencias')
                                        .doc(p.id)
                                        .delete();
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
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
