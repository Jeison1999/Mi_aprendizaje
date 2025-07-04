import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import 'user_detail_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchBy = 'cedula';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por cédula o nombre',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _searchBy,
                  items: const [
                    DropdownMenuItem(value: 'cedula', child: Text('Cédula')),
                    DropdownMenuItem(value: 'nombre', child: Text('Nombre')),
                  ],
                  onChanged: (v) => setState(() => _searchBy = v ?? 'cedula'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StatefulBuilder(
                builder: (context, setStateSB) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) {
                        return const Center(
                          child: Text(
                            'Ingrese un criterio de búsqueda para ver resultados.',
                          ),
                        );
                      }
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('usuarios')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No se encontraron usuarios.'),
                            );
                          }
                          var users = snapshot.data!.docs
                              .map(
                                (doc) => AppUser.fromMap(
                                  doc.data() as Map<String, dynamic>,
                                  doc.id,
                                ),
                              )
                              .toList();
                          final query = value.text.trim().toLowerCase();
                          if (_searchBy == 'nombre') {
                            users = users
                                .where(
                                  (u) => u.nombre.toLowerCase().contains(query),
                                )
                                .toList();
                          } else if (_searchBy == 'cedula') {
                            users = users
                                .where(
                                  (u) => u.cedula.toLowerCase().contains(query),
                                )
                                .toList();
                          }
                          if (users.isEmpty) {
                            return const Center(
                              child: Text('No se encontraron usuarios.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return ListTile(
                                title: Text(user.nombre),
                                subtitle: Text(
                                  'Cédula: ${user.cedula} | Tipo: '
                                  '${user.rol == UserRole.instructorPlanta
                                      ? 'Instructor de planta'
                                      : user.rol == UserRole.instructorContratista
                                      ? 'Instructor contratista'
                                      : user.rol == UserRole.aprendiz
                                      ? 'Aprendiz'
                                      : user.rol == UserRole.administrativo
                                      ? 'Administrativo'
                                      : user.rol == UserRole.teo
                                      ? 'TEO'
                                      : user.rol == UserRole.visitante
                                      ? 'Visitante'
                                      : user.rol == UserRole.otro && user.otroTipo != null
                                      ? 'Otro (${user.otroTipo})'
                                      : 'Otro'}',
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UserDetailPage(user: user),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
