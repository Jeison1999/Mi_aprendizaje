import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/movimiento_model.dart';
import '../../../pertenencias/domain/models/pertenencia_model.dart';
import 'scan_serial_page.dart';
import '../../../auth/domain/services/auth_service.dart';

class RegistrarMovimientoPage extends StatefulWidget {
  final Pertenencia pertenencia;
  final String usuarioId;
  const RegistrarMovimientoPage({
    super.key,
    required this.pertenencia,
    required this.usuarioId,
  });

  @override
  State<RegistrarMovimientoPage> createState() =>
      _RegistrarMovimientoPageState();
}

class _RegistrarMovimientoPageState extends State<RegistrarMovimientoPage> {
  TipoMovimiento? _tipo;
  final TextEditingController _observacionController = TextEditingController();
  bool _loading = false;
  String _error = '';
  TipoMovimiento? _ultimoTipo;
  bool _movLoaded = false;

  // Filtros para historial
  TipoMovimiento? _filtroTipo;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  final TextEditingController _busquedaObsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarUltimoMovimiento();
  }

  Future<void> _cargarUltimoMovimiento() async {
    final snap = await FirebaseFirestore.instance
        .collection('movimientos')
        .where('pertenenciaId', isEqualTo: widget.pertenencia.id)
        .orderBy('fecha', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isNotEmpty) {
      final mov = snap.docs.first.data();
      setState(() {
        _ultimoTipo = TipoMovimiento.values.firstWhere(
          (e) => e.name == mov['tipo'],
          orElse: () => TipoMovimiento.entrada,
        );
        _tipo = _ultimoTipo == TipoMovimiento.entrada
            ? TipoMovimiento.salida
            : TipoMovimiento.entrada;
        _movLoaded = true;
      });
    } else {
      setState(() {
        _tipo = TipoMovimiento.entrada;
        _movLoaded = true;
      });
    }
  }

  Future<void> _registrar() async {
    if (_tipo == null) return;
    if (_tipo == TipoMovimiento.salida &&
        widget.pertenencia.serial != null &&
        widget.pertenencia.serial!.isNotEmpty) {
      // Forzar escaneo y validación del serial
      final code = await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScanSerialPage()));
      if (code == null || code != widget.pertenencia.serial) {
        setState(() {
          _error = 'El serial escaneado no coincide con el registrado.';
        });
        return;
      }
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      // Obtener el email del usuario actual para auditoría
      final authService = AuthService();
      final currentUserEmail = authService.getCurrentUserEmail();

      final movimiento = Movimiento(
        id: '',
        pertenenciaId: widget.pertenencia.id,
        usuarioId: widget.usuarioId,
        tipo: _tipo!,
        fecha: DateTime.now(),
        observacion: _observacionController.text.trim().isEmpty
            ? null
            : _observacionController.text.trim(),
        registradoPor: currentUserEmail,
      );
      await FirebaseFirestore.instance
          .collection('movimientos')
          .add(movimiento.toMap());
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _error = 'Error al registrar: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_movLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar movimiento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Pertenencia: ${widget.pertenencia.descripcion}'),
            const SizedBox(height: 16),
            DropdownButtonFormField<TipoMovimiento>(
              value: _tipo,
              items: [
                if (_ultimoTipo == null || _ultimoTipo == TipoMovimiento.salida)
                  const DropdownMenuItem(
                    value: TipoMovimiento.entrada,
                    child: Text('Entrada'),
                  ),
                if (_ultimoTipo == TipoMovimiento.entrada)
                  const DropdownMenuItem(
                    value: TipoMovimiento.salida,
                    child: Text('Salida'),
                  ),
              ],
              onChanged: (v) => setState(() => _tipo = v),
              decoration: const InputDecoration(
                labelText: 'Tipo de movimiento',
              ),
              validator: (v) => v == null ? 'Seleccione un tipo' : null,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observacionController,
              decoration: const InputDecoration(
                labelText: 'Observación (opcional)',
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  if (widget.pertenencia.tipo == PertenenciaTipo.equipo ||
                      widget.pertenencia.serial != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear serial/código'),
                      onPressed: () async {
                        final code = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ScanSerialPage(),
                          ),
                        );
                        if (code != null && code is String) {
                          if (widget.pertenencia.serial != null &&
                              widget.pertenencia.serial!.isNotEmpty) {
                            if (code != widget.pertenencia.serial) {
                              setState(() {
                                _error =
                                    'El serial escaneado no coincide con el registrado.';
                              });
                              return;
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Serial/código verificado: $code'),
                            ),
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Historial de movimientos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Filtros
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<TipoMovimiento?>(
                          value: _filtroTipo,
                          isExpanded: true,
                          hint: const Text('Tipo'),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Todos')),
                            DropdownMenuItem(
                              value: TipoMovimiento.entrada,
                              child: Text('Entrada'),
                            ),
                            DropdownMenuItem(
                              value: TipoMovimiento.salida,
                              child: Text('Salida'),
                            ),
                          ],
                          onChanged: (v) => setState(() => _filtroTipo = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _fechaInicio ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _fechaInicio = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Desde',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Text(
                              _fechaInicio == null
                                  ? ''
                                  : '${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _fechaFin ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => _fechaFin = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hasta',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Text(
                              _fechaFin == null
                                  ? ''
                                  : '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _busquedaObsController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por observación',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('movimientos')
                          .where(
                            'pertenenciaId',
                            isEqualTo: widget.pertenencia.id,
                          )
                          .orderBy('fecha', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('Sin movimientos registrados.'),
                          );
                        }
                        // Aplicar filtros en memoria
                        var movimientos = snapshot.data!.docs
                            .map(
                              (doc) => Movimiento.fromMap(
                                doc.data() as Map<String, dynamic>,
                                doc.id,
                              ),
                            )
                            .toList();
                        if (_filtroTipo != null) {
                          movimientos = movimientos
                              .where((m) => m.tipo == _filtroTipo)
                              .toList();
                        }
                        if (_fechaInicio != null) {
                          movimientos = movimientos
                              .where(
                                (m) => m.fecha.isAfter(
                                  _fechaInicio!.subtract(
                                    const Duration(days: 1),
                                  ),
                                ),
                              )
                              .toList();
                        }
                        if (_fechaFin != null) {
                          movimientos = movimientos
                              .where(
                                (m) => m.fecha.isBefore(
                                  _fechaFin!.add(const Duration(days: 1)),
                                ),
                              )
                              .toList();
                        }
                        if (_busquedaObsController.text.isNotEmpty) {
                          final query = _busquedaObsController.text
                              .toLowerCase();
                          movimientos = movimientos
                              .where(
                                (m) => (m.observacion ?? '')
                                    .toLowerCase()
                                    .contains(query),
                              )
                              .toList();
                        }
                        if (movimientos.isEmpty) {
                          return const Center(
                            child: Text(
                              'Sin movimientos con los filtros seleccionados.',
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: movimientos.length,
                          itemBuilder: (context, index) {
                            final m = movimientos[index];
                            return ListTile(
                              leading: Icon(
                                m.tipo == TipoMovimiento.entrada
                                    ? Icons.login
                                    : Icons.logout,
                                color: m.tipo == TipoMovimiento.entrada
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              title: Text(
                                m.tipo == TipoMovimiento.entrada
                                    ? 'Entrada'
                                    : 'Salida',
                              ),
                              subtitle: Text(
                                'Fecha: ${_formatearFecha(m.fecha)}\nUsuario: ${m.registradoPor ?? 'Desconocido'}\nObs: ${m.observacion ?? '-'}',
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
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _registrar,
                child: const Text('Registrar'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    // Ejemplo: 04/07/2025 14:30
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
