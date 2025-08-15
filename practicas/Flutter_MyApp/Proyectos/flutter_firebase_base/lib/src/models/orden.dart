class Orden {
  final String id;
  final String idDocumento;
  final String orden;
  final DateTime fecha;
  final String idHistoria;
  final String idProfesionalOrdena;
  final bool profesionalExterno;

  Orden({
    required this.id,
    required this.idDocumento,
    required this.orden,
    required this.fecha,
    required this.idHistoria,
    required this.idProfesionalOrdena,
    required this.profesionalExterno,
  });

  factory Orden.fromMap(Map<String, dynamic> map) {
    return Orden(
      id: (map['id'] ?? '').toString(),
      idDocumento: (map['id_documento'] ?? '').toString(),
      orden: (map['orden'] ?? '').toString(),
      fecha: map['fecha'] != null && map['fecha'].toString().isNotEmpty
          ? DateTime.tryParse(map['fecha'].toString()) ?? DateTime(2000, 1, 1)
          : DateTime(2000, 1, 1),
      idHistoria: (map['id_historia'] ?? '').toString(),
      idProfesionalOrdena: (map['id_profesional_ordena'] ?? '').toString(),
      profesionalExterno: map['profesional_externo'] ?? false,
    );
  }
}
