import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/pertenencia_model.dart';
import '../pages/edit_pertenencia_page.dart';
import '../../../movimientos/presentation/pages/registrar_movimiento_page.dart';

class PertenenciaFilterSection extends StatefulWidget {
  final String userId;
  const PertenenciaFilterSection({super.key, required this.userId});

  @override
  State<PertenenciaFilterSection> createState() =>
      _PertenenciaFilterSectionState();
}

class _PertenenciaFilterSectionState extends State<PertenenciaFilterSection> {
  PertenenciaTipo? _filtroTipo;
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final isTablet =
            constraints.maxWidth > 600 && constraints.maxWidth <= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterHeader(
              isDesktop: isDesktop,
              filtroTipo: _filtroTipo,
              busquedaController: _busquedaController,
              onTipoChanged: (v) => setState(() => _filtroTipo = v),
              onBusquedaChanged: () => setState(() {}),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFF0A8754),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pertenencias Registradas',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                    return _buildEmptyState('Sin pertenencias registradas.');
                  }

                  var pertenencias = snapshot.data!.docs
                      .map(
                        (doc) => Pertenencia.fromMap(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        ),
                      )
                      .toList();

                  // Filtros en memoria
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
                    return _buildEmptyState(
                      'No se encontraron resultados con los filtros actuales.',
                    );
                  }

                  // Grid Responsive
                  int crossAxisCount = 1;
                  double childAspectRatio = 2.2; // Mobile default

                  if (isDesktop) {
                    crossAxisCount = 3;
                    childAspectRatio = 1.8;
                  } else if (isTablet) {
                    crossAxisCount = 2;
                    childAspectRatio = 1.6;
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                      mainAxisExtent: 180, // Altura fija para consistencia
                    ),
                    itemCount: pertenencias.length,
                    itemBuilder: (context, index) {
                      final p = pertenencias[index];
                      return _PertenenciaCard(
                        pertenencia: p,
                        userId: widget.userId,
                        index: index,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.montserrat(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  final bool isDesktop;
  final PertenenciaTipo? filtroTipo;
  final TextEditingController busquedaController;
  final ValueChanged<PertenenciaTipo?> onTipoChanged;
  final VoidCallback onBusquedaChanged;

  const _FilterHeader({
    required this.isDesktop,
    required this.filtroTipo,
    required this.busquedaController,
    required this.onTipoChanged,
    required this.onBusquedaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list, color: Color(0xFF0A8754)),
                const SizedBox(width: 8),
                Text(
                  'Filtros de búsqueda',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A8754),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              children: [
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PertenenciaTipo?>(
                        value: filtroTipo,
                        isExpanded: true,
                        hint: Text(
                          'Tipo de Pertenencia',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey[600],
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Todos',
                              style: GoogleFonts.montserrat(),
                            ),
                          ),
                          ...PertenenciaTipo.values.map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(
                                tipo.name.toUpperCase(),
                                style: GoogleFonts.montserrat(),
                              ),
                            ),
                          ),
                        ],
                        onChanged: onTipoChanged,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF0A8754),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 0, height: isDesktop ? 0 : 12),
                Expanded(
                  flex: isDesktop ? 2 : 0,
                  child: TextField(
                    controller: busquedaController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, marca, serial...',
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0A8754)),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF0A8754),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    style: GoogleFonts.montserrat(),
                    onChanged: (_) => onBusquedaChanged(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PertenenciaCard extends StatelessWidget {
  final Pertenencia pertenencia;
  final String userId;
  final int index;

  const _PertenenciaCard({
    required this.pertenencia,
    required this.userId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(pertenencia.tipo);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 50),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - value.clamp(0.0, 1.0)) * 20),
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Indicador de tipo (barra lateral)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(color: color),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconForType(pertenencia.tipo),
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pertenencia.tipo.name.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pertenencia.marca ?? 'Sin marca',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D3748),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (pertenencia.descripcion.isNotEmpty)
                            Text(
                              pertenencia.descripcion,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const Spacer(),
                          if (pertenencia.serial != null &&
                              pertenencia.serial!.isNotEmpty)
                            _InfoBadge(
                              label: 'Serial',
                              value: pertenencia.serial!,
                              color: color,
                            ),
                          if (pertenencia.placa != null &&
                              pertenencia.placa!.isNotEmpty)
                            _InfoBadge(
                              label: 'Placa',
                              value: pertenencia.placa!,
                              color: color,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _ActionButton(
                          icon: Icons.qr_code,
                          color: const Color(0xFF0A8754),
                          onTap: () => _navigateToMovement(context),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.edit_outlined,
                          color: Colors.orange,
                          onTap: () => _navigateToEdit(context),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          icon: Icons.delete_outline,
                          color: Colors.red,
                          onTap: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForType(PertenenciaTipo tipo) {
    switch (tipo) {
      case PertenenciaTipo.equipo:
        return const Color(0xFF0A8754);
      case PertenenciaTipo.vehiculo:
        return const Color(0xFF1976D2);
      default:
        return const Color(0xFF757575);
    }
  }

  IconData _getIconForType(PertenenciaTipo tipo) {
    switch (tipo) {
      case PertenenciaTipo.equipo:
        return Icons.computer;
      case PertenenciaTipo.vehiculo:
        return Icons.directions_car;
      default:
        return Icons.build;
    }
  }

  Future<void> _navigateToMovement(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegistrarMovimientoPage(
          pertenencia: pertenencia,
          usuarioId: userId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movimiento registrado exitosamente'),
          backgroundColor: Color(0xFF0A8754),
        ),
      );
    }
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditPertenenciaPage(pertenencia: pertenencia),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Eliminar Pertenencia',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${pertenencia.descripcion}"? Esta acción no se puede deshacer.',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.montserrat(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Eliminar',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('pertenencias')
          .doc(pertenencia.id)
          .delete();
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
