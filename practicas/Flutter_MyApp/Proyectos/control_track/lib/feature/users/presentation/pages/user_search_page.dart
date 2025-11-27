import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';
import 'user_detail_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchBy = 'nombre';
  UserRole? _filterByRole;
  TipoDocumento? _filterByDocType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getRoleLabel(UserRole role, String? otroTipo) {
    switch (role) {
      case UserRole.instructorPlanta:
        return 'Instructor de planta';
      case UserRole.instructorContratista:
        return 'Instructor contratista';
      case UserRole.aprendiz:
        return 'Aprendiz';
      case UserRole.administrativo:
        return 'Administrativo';
      case UserRole.teo:
        return 'TEO';
      case UserRole.visitante:
        return 'Visitante';
      case UserRole.otro:
        return otroTipo != null ? 'Otro ($otroTipo)' : 'Otro';
    }
  }

  String _getDocTypeLabel(TipoDocumento tipo) {
    switch (tipo) {
      case TipoDocumento.ti:
        return 'TI';
      case TipoDocumento.cc:
        return 'CC';
      case TipoDocumento.pasaporte:
        return 'Pasaporte';
      case TipoDocumento.cedulaExtranjera:
        return 'CE';
    }
  }

  List<AppUser> _filterUsers(List<AppUser> users, String query) {
    var filtered = users;

    // Filtrar por texto de búsqueda
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((user) {
        switch (_searchBy) {
          case 'nombre':
            return user.nombre.toLowerCase().contains(lowerQuery);
          case 'cedula':
            return user.cedula.toLowerCase().contains(lowerQuery);
          case 'correo':
            return user.correo.toLowerCase().contains(lowerQuery);
          default:
            return false;
        }
      }).toList();
    }

    // Filtrar por rol
    if (_filterByRole != null) {
      filtered = filtered.where((user) => user.rol == _filterByRole).toList();
    }

    // Filtrar por tipo de documento
    if (_filterByDocType != null) {
      filtered = filtered
          .where((user) => user.tipoDocumento == _filterByDocType)
          .toList();
    }

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _filterByRole = null;
      _filterByDocType = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Buscar usuario',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const AnimatedGradientBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Logo
                    Hero(
                      tag: 'logo_sena',
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/logo_sena.png',
                            fit: BoxFit.contain,
                            height: 54,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.account_circle,
                              size: 54,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Buscar usuario',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Busca y filtra usuarios del sistema',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Contenedor de búsqueda y filtros
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? size.width * 0.15
                            : size.width * 0.06,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF0A8754).withOpacity(0.10),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Barra de búsqueda
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Buscar usuario',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Dropdown de criterio de búsqueda
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A8754),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _searchBy,
                                    dropdownColor: Colors.white,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'nombre',
                                        child: Text(
                                          'Nombre',
                                          style: TextStyle(
                                            color: Color(0xFF0A8754),
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'cedula',
                                        child: Text(
                                          'Documento',
                                          style: TextStyle(
                                            color: Color(0xFF0A8754),
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'correo',
                                        child: Text(
                                          'Correo',
                                          style: TextStyle(
                                            color: Color(0xFF0A8754),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (v) => setState(
                                      () => _searchBy = v ?? 'nombre',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Filtros avanzados
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Filtro por rol
                              DropdownButton<UserRole?>(
                                value: _filterByRole,
                                hint: const Text(
                                  'Filtrar por rol',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todos los roles'),
                                  ),
                                  ...UserRole.values.map(
                                    (role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(_getRoleLabel(role, null)),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _filterByRole = v),
                              ),
                              const SizedBox(width: 8),
                              // Filtro por tipo de documento
                              DropdownButton<TipoDocumento?>(
                                value: _filterByDocType,
                                hint: const Text(
                                  'Filtrar por doc.',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black87,
                                  fontSize: 13,
                                ),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todos los tipos'),
                                  ),
                                  ...TipoDocumento.values.map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(_getDocTypeLabel(tipo)),
                                    ),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _filterByDocType = v),
                              ),
                              // Botón limpiar filtros
                              if (_filterByRole != null ||
                                  _filterByDocType != null ||
                                  _searchController.text.isNotEmpty)
                                TextButton.icon(
                                  onPressed: _clearFilters,
                                  icon: const Icon(Icons.clear, size: 16),
                                  label: const Text(
                                    'Limpiar',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade700,
                                  ),
                                ),
                            ],
                          ),

                          // Chips de filtros activos
                          if (_filterByRole != null || _filterByDocType != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Wrap(
                                spacing: 8,
                                children: [
                                  if (_filterByRole != null)
                                    Chip(
                                      label: Text(
                                        _getRoleLabel(_filterByRole!, null),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      deleteIcon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onDeleted: () =>
                                          setState(() => _filterByRole = null),
                                      backgroundColor: const Color(
                                        0xFF0A8754,
                                      ).withOpacity(0.1),
                                    ),
                                  if (_filterByDocType != null)
                                    Chip(
                                      label: Text(
                                        _getDocTypeLabel(_filterByDocType!),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      deleteIcon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      onDeleted: () => setState(
                                        () => _filterByDocType = null,
                                      ),
                                      backgroundColor: const Color(
                                        0xFF0A8754,
                                      ).withOpacity(0.1),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Resultados
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? size.width * 0.15
                            : size.width * 0.04,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      height: isDesktop
                          ? size.height * 0.5
                          : size.height * 0.45,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('usuarios')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return _buildEmptyState(
                              Icons.person_off_rounded,
                              'No hay usuarios registrados',
                            );
                          }

                          var users = snapshot.data!.docs
                              .map(
                                (doc) => AppUser.fromMap(
                                  doc.data() as Map<String, dynamic>,
                                  doc.id,
                                ),
                              )
                              .toList();

                          final filteredUsers = _filterUsers(
                            users,
                            _searchController.text.trim(),
                          );

                          if (filteredUsers.isEmpty) {
                            return _buildEmptyState(
                              Icons.person_search_rounded,
                              'No se encontraron usuarios',
                            );
                          }

                          return ListView.separated(
                            itemCount: filteredUsers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return _buildUserCard(user, isDesktop);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(AppUser user, bool isDesktop) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => UserDetailPage(user: user)));
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: const Color(0xFF0A8754).withOpacity(0.10),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0A8754).withOpacity(0.13),
                child: const Icon(Icons.person, color: Color(0xFF0A8754)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nombre,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF0A8754),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getDocTypeLabel(user.tipoDocumento),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            user.cedula,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getRoleLabel(user.rol, user.otroTipo),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF0A8754),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
