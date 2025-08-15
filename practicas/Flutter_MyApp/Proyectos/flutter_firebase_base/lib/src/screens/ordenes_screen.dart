import 'package:flutter/material.dart';
import '../models/orden.dart';
import '../services/orden_service.dart';

class OrdenesScreen extends StatefulWidget {
  final String idDocumento;
  const OrdenesScreen({super.key, required this.idDocumento});

  @override
  State<OrdenesScreen> createState() => _OrdenesScreenState();
}

class _OrdenesScreenState extends State<OrdenesScreen> {
  int _currentPage = 1;
  int _totalPages = 1;
  List<Orden> _ordenes = [];
  bool _loading = false;
  String _orderBy = 'desc';
  String _searchOrden = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _fetchOrdenes() async {
    setState(() => _loading = true);
    final service = OrdenService();
    List<Orden> ordenes = await service.getOrdenesPorPaciente(
      widget.idDocumento,
    );
    // Filtro por número de orden
    if (_searchOrden.isNotEmpty) {
      ordenes = ordenes.where((o) => o.orden.contains(_searchOrden)).toList();
    }
    // Filtro por rango de fechas
    if (_fechaInicio != null && _fechaFin != null) {
      ordenes = ordenes
          .where(
            (o) =>
                o.fecha.isAfter(_fechaInicio!) && o.fecha.isBefore(_fechaFin!),
          )
          .toList();
    }
    // Ordenar
    ordenes.sort(
      (a, b) => _orderBy == 'desc'
          ? b.fecha.compareTo(a.fecha)
          : a.fecha.compareTo(b.fecha),
    );
    // Paginación
    _totalPages = (ordenes.length / 10).ceil();
    final start = (_currentPage - 1) * 10;
    final end = (_currentPage * 10).clamp(0, ordenes.length);
    setState(() {
      _ordenes = ordenes.sublist(start, end);
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrdenes();
  }

  Future<void> _crearOrdenesDePrueba() async {
    setState(() => _loading = true);
    final service = OrdenService();
    await service.crearOrdenesDePrueba(widget.idDocumento);
    await _fetchOrdenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Laboratorio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear 10 órdenes de prueba',
            onPressed: _loading ? null : _crearOrdenesDePrueba,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar por número de orden',
                    ),
                    onChanged: (v) {
                      _searchOrden = v;
                      _currentPage = 1;
                      _fetchOrdenes();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    child: const Text('Filtrar por fechas'),
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        _fechaInicio = picked.start;
                        _fechaFin = picked.end;
                        _currentPage = 1;
                        _fetchOrdenes();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _orderBy == 'desc'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  onPressed: () {
                    setState(() {
                      _orderBy = _orderBy == 'desc' ? 'asc' : 'desc';
                      _fetchOrdenes();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _ordenes.isEmpty
                  ? const Center(child: Text('No se encontraron órdenes.'))
                  : ListView.builder(
                      itemCount: _ordenes.length,
                      itemBuilder: (context, index) {
                        final orden = _ordenes[index];
                        return Card(
                          child: ListTile(
                            title: Text('Orden: ${orden.orden}'),
                            subtitle: Text('Fecha: ${orden.fecha.toLocal()}'),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/resultados',
                                arguments: orden.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() {
                            _currentPage--;
                            _fetchOrdenes();
                          });
                        }
                      : null,
                ),
                Text('Página $_currentPage de $_totalPages'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < _totalPages
                      ? () {
                          setState(() {
                            _currentPage++;
                            _fetchOrdenes();
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
