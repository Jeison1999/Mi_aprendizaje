enum PertenenciaTipo { equipo, herramienta, vehiculo, otro }

class Pertenencia {
  final String id;
  final String usuarioId;
  final PertenenciaTipo tipo;
  final String descripcion;
  final String? serial;
  final String? marca;
  final String? modelo;
  final String? placa;
  final String? tipoVehiculo;
  final DateTime fechaRegistro;

  // Campos de auditoría
  final String? creadoPor;
  final String? modificadoPor;
  final DateTime? fechaModificacion;

  Pertenencia({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.descripcion,
    this.serial,
    this.marca,
    this.modelo,
    this.placa,
    this.tipoVehiculo,
    required this.fechaRegistro,
    this.creadoPor,
    this.modificadoPor,
    this.fechaModificacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'tipo': tipo.name,
      'descripcion': descripcion,
      'serial': serial,
      'marca': marca,
      'modelo': modelo,
      'placa': placa,
      'tipoVehiculo': tipoVehiculo,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'creadoPor': creadoPor,
      'modificadoPor': modificadoPor,
      'fechaModificacion': fechaModificacion?.toIso8601String(),
    };
  }

  factory Pertenencia.fromMap(Map<String, dynamic> map, String id) {
    return Pertenencia(
      id: id,
      usuarioId: map['usuarioId'] ?? '',
      tipo: PertenenciaTipo.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => PertenenciaTipo.otro,
      ),
      descripcion: map['descripcion'] ?? '',
      serial: map['serial'],
      marca: map['marca'],
      modelo: map['modelo'],
      placa: map['placa'],
      tipoVehiculo: map['tipoVehiculo'],
      fechaRegistro:
          DateTime.tryParse(map['fechaRegistro'] ?? '') ?? DateTime.now(),
      creadoPor: map['creadoPor'],
      modificadoPor: map['modificadoPor'],
      fechaModificacion: map['fechaModificacion'] != null
          ? DateTime.tryParse(map['fechaModificacion'])
          : null,
    );
  }
}
