import 'package:flutter/material.dart';
import '../models/resultado.dart';
import '../services/resultado_service.dart';

class ResultadosScreen extends StatelessWidget {
  final String idOrden;
  const ResultadosScreen({super.key, required this.idOrden});

  Future<Map<String, List<Resultado>>> _getResultadosAgrupados() async {
    final service = ResultadoService();
    final resultados = await service.getResultadosPorOrden(idOrden);
    // Agrupar por procedimiento (puedes ajustar el campo según tu modelo)
    final Map<String, List<Resultado>> grupos = {};
    for (var r in resultados) {
      final grupo = r.idProcedimiento;
      grupos.putIfAbsent(grupo, () => []).add(r);
    }
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados de la orden')),
      body: FutureBuilder<Map<String, List<Resultado>>>(
        future: _getResultadosAgrupados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los resultados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron resultados.'));
          } else {
            final grupos = snapshot.data!;
            return ListView(
              children: grupos.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    title: Text('Grupo: ${entry.key}'),
                    children: entry.value.map((r) {
                      return ListTile(
                        title: Text('Prueba: ${r.idPrueba}'),
                        subtitle: Text(
                          'Resultado: ${r.resNumerico} ${r.resTexto}',
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
