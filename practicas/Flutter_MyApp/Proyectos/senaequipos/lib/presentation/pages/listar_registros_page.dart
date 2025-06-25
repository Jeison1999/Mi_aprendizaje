import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/registro_equipo.dart';
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
      _registrosFuture = repo.listarRegistros().then(
        (registros) =>
            registros.where((r) => r.cedula.value == cedula).toList(),
      );
    });
  }

  Future<void> _eliminarRegistro(RegistroEquipo registro) async {
    final eliminar = GetIt.I<EliminarRegistroEquipo>();
    try {
      await eliminar.call(
        cedula: registro.cedula.value,
        serial: registro.serial.value,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _buscarPorCedula();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF39A900), Color(0xFFB6FFB0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            left: -40,
            child: _Bubble(color: Colors.white.withOpacity(0.08), size: 180),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: _Bubble(color: Colors.white.withOpacity(0.10), size: 120),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width > 400 ? 80 : 16,
                  vertical: 24,
                ),
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 34,
                            color: Color(0xFF39A900),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Buscar equipos',
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF222222),
                                ) ??
                                const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cedulaController,
                              decoration: const InputDecoration(
                                labelText: 'Cédula del aprendiz',
                                prefixIcon: Icon(Icons.badge_rounded),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.search_rounded),
                            label: const Text('Buscar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            onPressed: _buscarPorCedula,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_registrosFuture != null)
                        SizedBox(
                          height: size.height * 0.55,
                          child: FutureBuilder<List<RegistroEquipo>>(
                            future: _registrosFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: \\${snapshot.error}'),
                                );
                              }
                              final registros = snapshot.data ?? [];
                              if (registros.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No hay equipos para esta cédula.',
                                  ),
                                );
                              }
                              return ListView.separated(
                                itemCount: registros.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, i) {
                                  final r = registros[i];
                                  final horaEntrada =
                                      '${r.horaEntrada.value.hour.toString().padLeft(2, '0')}:${r.horaEntrada.value.minute.toString().padLeft(2, '0')}';
                                  final horaSalida = r.horaSalida != null
                                      ? '${r.horaSalida!.value.hour.toString().padLeft(2, '0')}:${r.horaSalida!.value.minute.toString().padLeft(2, '0')}'
                                      : 'No registrada';
                                  return Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.devices_other_rounded,
                                        color: Color(0xFF39A900),
                                      ),
                                      title: Text(
                                        'Serial: ${r.serial.value}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Nombre: ${r.nombre.value}\n'
                                        'Característica: ${r.caracteristica.value}\n'
                                        'Entrada: $horaEntrada\n'
                                        'Salida: $horaSalida',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
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
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
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
                                        final actualizado =
                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditarRegistroPage(
                                                      registro: r,
                                                    ),
                                              ),
                                            );
                                        if (actualizado == true) {
                                          _buscarPorCedula();
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final Color color;
  final double size;

  const _Bubble({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
