import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/movimiento_model.dart';
import '../data/models/pertenencia_model.dart';
import 'scan_serial_page.dart';

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
      final movimiento = Movimiento(
        id: '',
        pertenenciaId: widget.pertenencia.id,
        usuarioId: widget.usuarioId,
        tipo: _tipo!,
        fecha: DateTime.now(),
        observacion: _observacionController.text.trim().isEmpty
            ? null
            : _observacionController.text.trim(),
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
                        final movimientos = snapshot.data!.docs
                            .map(
                              (doc) => Movimiento.fromMap(
                                doc.data() as Map<String, dynamic>,
                                doc.id,
                              ),
                            )
                            .toList();
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
                                'Fecha: ${m.fecha.toLocal()}\nObs: ${m.observacion ?? '-'}',
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
}
