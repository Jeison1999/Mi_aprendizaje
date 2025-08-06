import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/crear_grupo_modal.dart';
import '../widgets/editar_grupo_modal.dart';
import 'productos_por_grupo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PanelAdmin extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const PanelAdmin({super.key, required this.usuario});

  @override
  _PanelAdminState createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin> {
  Future<void> eliminarGrupo(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('$apiUrl/api/grupos/$id');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Grupo eliminado correctamente')));
      cargarGrupos();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al eliminar grupo')));
    }
  }

  List grupos = [];

  @override
  void initState() {
    super.initState();
    cargarGrupos();
  }

  void cargarGrupos() async {
    final data = await ApiService.getGrupos();
    setState(() {
      grupos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Panel Admin - ${widget.usuario['nombre']}")),
      body: grupos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: grupos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductosPorGrupoScreen(
                          grupoId: grupo['id'],
                          grupoNombre: grupo['nombre'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            grupo['imagen_url'] ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.image_not_supported),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            grupo['nombre'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final actualizado = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => EditarGrupoModal(
                                    grupo: grupo,
                                    onGrupoActualizado: () {},
                                  ),
                                );
                                if (actualizado == true) {
                                  cargarGrupos();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => eliminarGrupo(grupo['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CrearGrupoModal(
              onGrupoCreado: () {
                cargarGrupos();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
