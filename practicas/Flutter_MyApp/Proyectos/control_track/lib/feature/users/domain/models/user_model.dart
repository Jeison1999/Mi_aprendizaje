enum TipoDocumento { ti, cc, pasaporte, cedulaExtranjera }

enum UserRole {
  aprendiz,
  instructorPlanta,
  instructorContratista,
  administrativo,
  teo,
  visitante,
  otro,
}

class AppUser {
  final String id;
  final String nombre;
  final TipoDocumento tipoDocumento;
  final String cedula;
  final String celular;
  final String correo;
  final UserRole rol;
  final String? otroTipo;

  // Campos de auditoría
  final String? creadoPor;
  final String? modificadoPor;
  final DateTime? fechaCreacion;
  final DateTime? fechaModificacion;

  AppUser({
    required this.id,
    required this.nombre,
    required this.tipoDocumento,
    required this.cedula,
    required this.celular,
    required this.correo,
    required this.rol,
    this.otroTipo,
    this.creadoPor,
    this.modificadoPor,
    this.fechaCreacion,
    this.fechaModificacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'tipoDocumento': tipoDocumento.name,
      'cedula': cedula,
      'celular': celular,
      'correo': correo,
      'rol': rol.name,
      'otroTipo': otroTipo,
      'creadoPor': creadoPor,
      'modificadoPor': modificadoPor,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
      'fechaModificacion': fechaModificacion?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      nombre: map['nombre'] ?? '',
      tipoDocumento: TipoDocumento.values.firstWhere(
        (e) => e.name == map['tipoDocumento'],
        orElse: () => TipoDocumento.cc,
      ),
      cedula: map['cedula'] ?? '',
      celular: map['celular'] ?? '',
      correo: map['correo'] ?? '',
      rol: UserRole.values.firstWhere(
        (e) => e.name == map['rol'],
        orElse: () => UserRole.otro,
      ),
      otroTipo: map['otroTipo'],
      creadoPor: map['creadoPor'],
      modificadoPor: map['modificadoPor'],
      fechaCreacion: map['fechaCreacion'] != null
          ? DateTime.parse(map['fechaCreacion'])
          : null,
      fechaModificacion: map['fechaModificacion'] != null
          ? DateTime.parse(map['fechaModificacion'])
          : null,
    );
  }
}
