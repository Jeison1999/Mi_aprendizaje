import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../application/use_cases/buscar_registro_equipo.dart';
import '../../application/use_cases/eliminar_registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';
import 'editar_registro_page.dart';

class ListarRegistrosPage extends StatefulWidget {
  const ListarRegistrosPage({super.key});

  @override
  State<ListarRegistrosPage> createState() => _ListarRegistrosPageState();
}

class _ListarRegistrosPageState extends State<ListarRegistrosPage> {
  final _cedulaController = TextEditingController();
  Future<List<RegistroEquipo>>? _registrosFuture;
  String? _cedulaBuscada;

  @override
  void dispose() {
    _cedulaController.dispose();
    super.dispose();
  }

  void _buscarPorCedula() {
    final cedula = _cedulaController.text.trim();
    if (cedula.isEmpty) return;
    final repo = GetIt.I<RegistroEquipoRepository>();
    setState(() {
      _cedulaBuscada = cedula;
      _registrosFuture = repo.listarRegistros().then(
        (registros) =>
            registros.where((r) => r.cedula.value == cedula).toList(),
      );
    });
  }

  Future<void> _eliminarRegistro(RegistroEquipo registro) async {
    final eliminar = GetIt.I<EliminarRegistroEquipo>();
    await eliminar.call(
      cedula: registro.cedula.value,
      serial: registro.serial.value,
    );
    _buscarPorCedula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar equipos por cédula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cedulaController,
                    decoration: const InputDecoration(
                      labelText: 'Cédula del aprendiz',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _buscarPorCedula,
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_registrosFuture != null)
              Expanded(
                child: FutureBuilder<List<RegistroEquipo>>(
                  future: _registrosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: \\${snapshot.error}'));
                    }
                    final registros = snapshot.data ?? [];
                    if (registros.isEmpty) {
                      return const Center(
                        child: Text('No hay equipos para esta cédula.'),
                      );
                    }
                    return ListView.separated(
                      itemCount: registros.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final r = registros[i];
                        final horaEntrada =
                            '${r.horaEntrada.value.hour.toString().padLeft(2, '0')}:${r.horaEntrada.value.minute.toString().padLeft(2, '0')}';
                        final horaSalida = r.horaSalida != null
                            ? '${r.horaSalida!.value.hour.toString().padLeft(2, '0')}:${r.horaSalida!.value.minute.toString().padLeft(2, '0')}'
                            : 'No registrada';
                        return ListTile(
                          leading: const Icon(Icons.devices),
                          title: Text('Serial: ${r.serial.value}'),
                          subtitle: Text(
                            'Nombre: ${r.nombre.value}\n'
                            'Característica: ${r.caracteristica.value}\n'
                            'Entrada: $horaEntrada\n'
                            'Salida: $horaSalida',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Eliminar'),
                                  content: const Text(
                                    '¿Seguro que deseas eliminar este registro?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _eliminarRegistro(r);
                              }
                            },
                          ),
                          onTap: () async {
                            final actualizado = await Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditarRegistroPage(registro: r),
                                  ),
                                );
                            if (actualizado == true) {
                              _buscarPorCedula();
                            }
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
