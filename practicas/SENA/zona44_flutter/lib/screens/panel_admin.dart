import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PanelAdmin extends StatefulWidget {
  final Map<String, dynamic> usuario;

  PanelAdmin({required this.usuario});

  @override
  _PanelAdminState createState() => _PanelAdminState();
}

class _PanelAdminState extends State<PanelAdmin> {
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
      appBar: AppBar(
        title: Text("Panel Admin - ${widget.usuario['nombre']}"),
      ),
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
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          grupo['imagen_url'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(grupo['nombre'], style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
