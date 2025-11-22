import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/pertenencia_model.dart';
import '../pages/edit_pertenencia_page.dart';
import '../../../movimientos/presentation/pages/registrar_movimiento_page.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
          child: Card(
            elevation: 4,
            color: const Color(0xFFF5F7FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: const Color(0xFF0A8754).withOpacity(0.10),
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.filter_alt_rounded,
                        color: Color(0xFF0A8754),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Filtrar pertenencias',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0A8754),
                          fontSize: 16.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF0A8754).withOpacity(0.13),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PertenenciaTipo?>(
                                value: _filtroTipo,
                                isExpanded: true,
                                hint: const Text('Tipo'),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todos'),
                                  ),
                                  ...PertenenciaTipo.values.map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo.name),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _filtroTipo = v),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF0A8754),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _busquedaController,
                          decoration: InputDecoration(
                            labelText: 'Buscar',
                            labelStyle: const TextStyle(
                              color: Color(0xFF0A8754),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: const Color(
                                  0xFF0A8754,
                                ).withOpacity(0.13),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: const Color(
                                  0xFF0A8754,
                                ).withOpacity(0.13),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0A8754),
                                width: 1.5,
                              ),
                            ),
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF0A8754),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14.5,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                color: Color(0xFF0A8754),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Pertenencias registradas',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 231, 234, 233),
                  fontSize: 17.5,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(32, 251, 251, 251),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                itemCount: pertenencias.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final p = pertenencias[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + index * 60),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) => Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, (1 - value.clamp(0.0, 1.0)) * 30),
                        child: child,
                      ),
                    ),
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: p.tipo == PertenenciaTipo.equipo
                              ? const Color(0xFF0A8754).withOpacity(0.18)
                              : p.tipo == PertenenciaTipo.vehiculo
                              ? const Color(0xFF1976D2).withOpacity(0.18)
                              : const Color(0xFF757575).withOpacity(0.13),
                          width: 1.3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: p.tipo == PertenenciaTipo.equipo
                                  ? const Color(0xFF0A8754).withOpacity(0.13)
                                  : p.tipo == PertenenciaTipo.vehiculo
                                  ? const Color(0xFF1976D2).withOpacity(0.13)
                                  : const Color(0xFF757575).withOpacity(0.13),
                              child: Icon(
                                p.tipo == PertenenciaTipo.equipo
                                    ? Icons.devices_other
                                    : p.tipo == PertenenciaTipo.vehiculo
                                    ? Icons.directions_car
                                    : Icons.handyman,
                                color: p.tipo == PertenenciaTipo.equipo
                                    ? const Color(0xFF0A8754)
                                    : p.tipo == PertenenciaTipo.vehiculo
                                    ? const Color(0xFF1976D2)
                                    : const Color(0xFF757575),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        p.tipo.name.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          color:
                                              p.tipo == PertenenciaTipo.equipo
                                              ? const Color(0xFF0A8754)
                                              : p.tipo ==
                                                    PertenenciaTipo.vehiculo
                                              ? const Color(0xFF1976D2)
                                              : const Color(0xFF757575),
                                          fontSize: 15.5,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                      if ((p.marca ?? '').isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            p.marca!,
                                            style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              fontSize: 14.5,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (p.descripcion.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.description,
                                            size: 16,
                                            color: Colors.black45,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              p.descripcion,
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black87,
                                                fontSize: 13.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (p.tipo == PertenenciaTipo.equipo &&
                                      p.serial != null &&
                                      p.serial!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.confirmation_number,
                                            size: 16,
                                            color: Color(0xFF0A8754),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Serial: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.2,
                                              color: Color(0xFF0A8754),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              p.serial!,
                                              style: const TextStyle(
                                                fontSize: 13.2,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (p.tipo == PertenenciaTipo.vehiculo &&
                                      p.placa != null &&
                                      p.placa!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.directions_car,
                                            size: 16,
                                            color: Color(0xFF1976D2),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Placa: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.2,
                                              color: Color(0xFF1976D2),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              p.placa!,
                                              style: const TextStyle(
                                                fontSize: 13.2,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _CircleActionButton(
                                  icon: Icons.qr_code,
                                  color: const Color(0xFF0A8754),
                                  tooltip: 'Registrar entrada/salida',
                                  onTap: () async {
                                    final result = await Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                RegistrarMovimientoPage(
                                                  pertenencia: p,
                                                  usuarioId: widget.userId,
                                                ),
                                          ),
                                        );
                                    if (result == true && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Movimiento registrado.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 7),
                                _CircleActionButton(
                                  icon: Icons.edit,
                                  color: Colors.orange,
                                  tooltip: 'Editar pertenencia',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditPertenenciaPage(pertenencia: p),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 7),
                                _CircleActionButton(
                                  icon: Icons.delete,
                                  color: Colors.red[700]!,
                                  tooltip: 'Eliminar pertenencia',
                                  onTap: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          'Eliminar pertenencia',
                                        ),
                                        content: const Text(
                                          '¿Estás seguro de eliminar esta pertenencia?',
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
                                            child: const Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
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
                          ],
                        ),
                      ),
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

// Botón de acción circular para acciones de pertenencia
class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 20)),
          ),
        ),
      ),
    );
  }
}
