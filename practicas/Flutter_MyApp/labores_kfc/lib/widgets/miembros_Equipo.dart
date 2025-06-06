// import 'package:flutter/foundation.dart};
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labores_kfc/widgets/form_agregar.dart';
import 'package:labores_kfc/widgets/form_editar.dart';
import 'package:labores_kfc/func/crear_pdf.dart'; // Importa tu función

class Miembros extends StatelessWidget {
  const Miembros({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Miembros'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: 'Generar PDF',
            onPressed: () async {
              await crearPDFUsuariosYLabor(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
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
                  border: Border.all(color: Colors.red, width: 2),
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
                            final data = usuario.data() as Map<String, dynamic>;
                            final laborId = data.containsKey('laborId')
                                ? data['laborId']
                                : null;
                            if (laborId == null) {
                              return Text(
                                'Sin labor asignada',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
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
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return Text(
                                    'Labor no encontrada',
                                    style: TextStyle(color: Colors.white),
                                  );
                                }
                                final laborData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;
                                return Text(
                                  'Labor: ${laborData['nombre'] ?? 'Sin nombre'}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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
                            backgroundColor: Colors.red,
                            child: Text(
                              usuario['inicial'],
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            usuario['nombre'],
                            style: TextStyle(
                              color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AgregarUsuarioDialog(),
          );
        },
      ),
    );
  }
}
