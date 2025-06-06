// import 'package:flutter/foundation.dart};
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labores_kfc/widgets/form_agregar.dart';
import 'package:labores_kfc/widgets/form_editar.dart';
import 'package:labores_kfc/func/crear_pdf.dart';

class Miembros extends StatelessWidget {
  const Miembros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón PDF
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD8001D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  icon: Icon(Icons.picture_as_pdf, size: 32),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear PDF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Usuarios y labores',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await crearPDFUsuariosYLabor(context);
                  },
                ),
                SizedBox(width: 18),
                // Botón Agregar usuario
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 6, 6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  icon: Icon(Icons.person_add_alt_1, size: 32),
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('Nuevo usuario', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AgregarUsuarioDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
          // ...el resto de tu body (por ejemplo, la lista de usuarios)...
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No hay usuarios'));
                }
                final usuarios = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return Container(
                      margin: EdgeInsets.all(12),
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD8001D),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 100,
                              width: 260,
                              padding: EdgeInsets.all(10),
                              child: Builder(
                                builder: (context) {
                                  final data =
                                      usuario.data() as Map<String, dynamic>;
                                  final laborId = data.containsKey('laborId')
                                      ? data['laborId']
                                      : null;
                                  if (laborId == null) {
                                    return Text(
                                      'Sin labor asignada',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: const Color.fromARGB(
                                          255,
                                          6,
                                          6,
                                          6,
                                        ),
                                      ),
                                    );
                                  }
                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('labores')
                                        .doc(laborId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          'Cargando labor...',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              10,
                                              10,
                                              10,
                                            ),
                                          ),
                                        );
                                      }
                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return Text(
                                          'Labor no encontrada',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              11,
                                              11,
                                              11,
                                            ),
                                          ),
                                        );
                                      }
                                      final laborData =
                                          snapshot.data!.data()
                                              as Map<String, dynamic>;
                                      return Text(
                                        'Labor: ${laborData['nombre'] ?? 'Sin nombre'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: const Color.fromARGB(
                                            255,
                                            12,
                                            12,
                                            12,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xFFD8001D),
                                  child: Text(
                                    usuario['inicial'],
                                    style: TextStyle(
                                      color: const Color.fromARGB(179, 7, 7, 7),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  usuario['nombre'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      10,
                                      10,
                                      10,
                                    ),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 10,
                            bottom: 0,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          EditarUsuarioDialog(usuario: usuario),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await usuario.reference.delete();
                                  },
                                ),
                              ],
                            ),
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
  }
}
