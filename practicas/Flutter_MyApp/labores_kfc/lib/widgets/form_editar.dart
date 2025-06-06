import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarUsuarioDialog extends StatefulWidget {
  final QueryDocumentSnapshot usuario;

  const EditarUsuarioDialog({super.key, required this.usuario});

  @override
  State<EditarUsuarioDialog> createState() => _EditarUsuarioDialogState();
}

class _EditarUsuarioDialogState extends State<EditarUsuarioDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _inicialController;
  late TextEditingController _laborController;
  String? laborIdSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario['nombre']);
    _inicialController = TextEditingController(text: widget.usuario['inicial']);
    _laborController = TextEditingController();

    // Verifica si el campo laborId existe de forma segura
    final data = widget.usuario.data() as Map<String, dynamic>;
    laborIdSeleccionada = data.containsKey('laborId') ? data['laborId'] : null;

    // Cargar el nombre de la labor actual si existe laborId
    if (laborIdSeleccionada != null) {
      FirebaseFirestore.instance
          .collection('labores')
          .doc(laborIdSeleccionada)
          .get()
          .then((doc) {
            if (doc.exists) {
              setState(() {
                _laborController.text = doc['nombre'] ?? '';
              });
            }
          });
    }
  }

  Future<List<Map<String, dynamic>>> obtenerLabores() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('labores')
        .get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, 'nombre': doc['nombre'] ?? 'Sin nombre'})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar usuario'),
      content: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('labores').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData) {
            return Text('No se pudieron cargar las labores.');
          }

          final labores = snapshot.data!.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'nombre': doc['nombre'] ?? 'Sin nombre',
                },
              )
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _inicialController,
                decoration: InputDecoration(labelText: 'Inicial'),
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final input = textEditingValue.text.trim();
                  final nombres = labores
                      .map((l) => l['nombre'] as String)
                      .toList();
                  final opciones = nombres
                      .where(
                        (option) =>
                            option.toLowerCase().contains(input.toLowerCase()),
                      )
                      .toList();

                  if (input.isNotEmpty && !nombres.contains(input)) {
                    opciones.insert(0, input);
                  }
                  return opciones;
                },
                onSelected: (String seleccionada) {
                  final labor = labores.firstWhere(
                    (l) => l['nombre'] == seleccionada,
                    orElse: () => <String, dynamic>{},
                  );
                  if (labor.isNotEmpty) {
                    laborIdSeleccionada = labor['id'];
                  } else {
                    laborIdSeleccionada =
                        null; // Es una nueva labor, se creará al guardar
                  }
                  _laborController.text = seleccionada;
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Material(
                    elevation: 4,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        final labor = labores.firstWhere(
                          (l) => l['nombre'] == option,
                          orElse: () => <String, dynamic>{},
                        );
                        return _LaborOptionTile(
                          option: option,
                          laborId: labor.isNotEmpty ? labor['id'] : null,
                          onSelected: onSelected,
                          onDeleted: labor.isNotEmpty
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('labores')
                                      .doc(labor['id'])
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Labor borrada')),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  );
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                      // Solo asigna el texto si está vacío para evitar loops
                      if (controller.text.isEmpty &&
                          _laborController.text.isNotEmpty) {
                        controller.text = _laborController.text;
                      }
                      controller.addListener(() {
                        _laborController.text = controller.text;
                      });
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(labelText: 'Labor'),
                      );
                    },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final nombre = _nombreController.text.trim();
            final inicial = _inicialController.text.trim();
            final laborNombre = _laborController.text.trim();

            // Si el usuario escribió un nombre de labor que no existe, crearla
            if (laborNombre.isNotEmpty && laborIdSeleccionada == null) {
              final nuevaLabor = await FirebaseFirestore.instance
                  .collection('labores')
                  .add({'nombre': laborNombre});
              laborIdSeleccionada = nuevaLabor.id;
            }

            if (nombre.isNotEmpty && inicial.isNotEmpty) {
              if (laborNombre.isEmpty) {
                // Eliminar laborId si el campo está vacío
                await widget.usuario.reference.update({
                  'nombre': nombre,
                  'inicial': inicial,
                  'laborId': FieldValue.delete(),
                });
              } else if (laborIdSeleccionada != null) {
                await widget.usuario.reference.update({
                  'nombre': nombre,
                  'inicial': inicial,
                  'laborId': laborIdSeleccionada,
                });
              }
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Por favor completa todos los campos.')),
              );
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}

class _LaborOptionTile extends StatefulWidget {
  final String option;
  final String? laborId;
  final void Function(String) onSelected;
  final Future<void> Function()? onDeleted;

  const _LaborOptionTile({
    required this.option,
    required this.laborId,
    required this.onSelected,
    this.onDeleted,
  });

  @override
  State<_LaborOptionTile> createState() => _LaborOptionTileState();
}

class _LaborOptionTileState extends State<_LaborOptionTile> {
  bool showDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.laborId != null
          ? () {
              setState(() {
                showDelete = true;
              });
            }
          : null,
      onTap: () {
        widget.onSelected(widget.option);
      },
      child: ListTile(
        title: Text(widget.option),
        trailing: showDelete && widget.onDeleted != null
            ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await widget.onDeleted!();
                  setState(() {
                    showDelete = false;
                  });
                },
              )
            : null,
      ),
    );
  }
}
