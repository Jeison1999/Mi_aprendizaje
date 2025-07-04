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
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchController.text.isEmpty
                    ? FirebaseFirestore.instance
                          .collection('usuarios')
                          .snapshots()
                    : FirebaseFirestore.instance
                          .collection('usuarios')
                          .where(
                            _searchBy,
                            isGreaterThanOrEqualTo: _searchController.text
                                .trim(),
                          )
                          .where(
                            _searchBy,
                            isLessThanOrEqualTo:
                                _searchController.text.trim() + '\uf8ff',
                          )
                          .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron usuarios.'),
                    );
                  }
                  final users = snapshot.data!.docs
                      .map(
                        (doc) => AppUser.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        ),
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.nombre),
                        subtitle: Text(
                          'Cédula: ${user.cedula} | Tipo: ${user.rol.name}',
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserDetailPage(user: user),
                            ),
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
