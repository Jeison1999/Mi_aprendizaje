import 'package:flutter/material.dart';
import 'package:zona44_app/screens/products_screen.dart';
import 'package:zona44_app/screens/admin/groups_admin_screen.dart';
import '../services/api_service.dart';
import '../models/group.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = ApiService().fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zona 44 - Menú')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GroupsAdminScreen()),
              );
              // Al volver, recarga la lista de grupos
              setState(() {
                _groupsFuture = ApiService().fetchGroups();
              });
            },
            child: Text('Administrar Grupos'),
          ),
          Expanded(
            child: FutureBuilder<List<Group>>(
              future: _groupsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: [${snapshot.error}'));
                } else {
                  final groups = snapshot.data!;
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return ListTile(
                        leading: const Icon(Icons.fastfood),
                        title: Text(group.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductsScreen(
                                groupId: group.id,
                                groupName: group.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
