import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/pertenencia_model.dart';
import 'edit_pertenencia_page.dart';
import 'registrar_movimiento_page.dart';

class PertenenciaFilterSection extends StatefulWidget {
  final String userId;
  const PertenenciaFilterSection({required this.userId});

  @override
  State<PertenenciaFilterSection> createState() =>
      _PertenenciaFilterSectionState();
}

class _PertenenciaFilterSectionState extends State<PertenenciaFilterSection> {
  PertenenciaTipo? _filtroTipo;
  final TextEditingController _busquedaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButton<PertenenciaTipo?>(
                value: _filtroTipo,
                isExpanded: true,
                hint: const Text('Tipo'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos')),
                  ...PertenenciaTipo.values.map(
                    (tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo.name)),
                  ),
                ],
                onChanged: (v) => setState(() => _filtroTipo = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _busquedaController,
                decoration: const InputDecoration(
                  labelText: 'Buscar',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('pertenencias')
                .where('usuarioId', isEqualTo: widget.userId)
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
              var pertenencias = snapshot.data!.docs
                  .map(
                    (doc) => Pertenencia.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();
              if (_filtroTipo != null) {
                pertenencias = pertenencias
                    .where((p) => p.tipo == _filtroTipo)
                    .toList();
              }
              if (_busquedaController.text.isNotEmpty) {
                final query = _busquedaController.text.toLowerCase();
                pertenencias = pertenencias.where((p) {
                  return (p.descripcion.toLowerCase().contains(query) ||
                      (p.marca ?? '').toLowerCase().contains(query) ||
                      (p.serial ?? '').toLowerCase().contains(query) ||
                      (p.placa ?? '').toLowerCase().contains(query));
                }).toList();
              }
              if (pertenencias.isEmpty) {
                return const Center(
                  child: Text(
                    'Sin pertenencias con los filtros seleccionados.',
                  ),
                );
              }
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
                        if (p.tipo == PertenenciaTipo.equipo &&
                            p.serial != null &&
                            p.serial!.isNotEmpty)
                          Text('Serial: ${p.serial}'),
                        if (p.tipo == PertenenciaTipo.vehiculo &&
                            p.placa != null &&
                            p.placa!.isNotEmpty)
                          Text('Placa: ${p.placa}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.qr_code, color: Colors.green),
                          tooltip: 'Registrar entrada/salida',
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RegistrarMovimientoPage(
                                  pertenencia: p,
                                  usuarioId: widget.userId,
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
                          icon: const Icon(Icons.edit, color: Colors.blue),
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
                          icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
