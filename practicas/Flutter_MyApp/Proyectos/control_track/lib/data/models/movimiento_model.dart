enum TipoMovimiento { entrada, salida }

class Movimiento {
  final String id;
  final String pertenenciaId;
  final String usuarioId;
  final TipoMovimiento tipo;
  final DateTime fecha;
  final String? observacion;

  Movimiento({
    required this.id,
    required this.pertenenciaId,
    required this.usuarioId,
    required this.tipo,
    required this.fecha,
    this.observacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pertenenciaId': pertenenciaId,
      'usuarioId': usuarioId,
      'tipo': tipo.name,
      'fecha': fecha.toIso8601String(),
      'observacion': observacion,
    };
  }

  factory Movimiento.fromMap(Map<String, dynamic> map, String id) {
    return Movimiento(
      id: id,
      pertenenciaId: map['pertenenciaId'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      tipo: TipoMovimiento.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoMovimiento.entrada,
      ),
      fecha: DateTime.parse(map['fecha']),
      observacion: map['observacion'],
    );
  }
}
