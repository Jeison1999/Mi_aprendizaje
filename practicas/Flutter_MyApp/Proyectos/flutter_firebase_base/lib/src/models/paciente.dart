class Paciente {
  final String id;
  final String tipoId;
  final String numeroId;
  final String nombre1;
  final String nombre2;
  final String apellido1;
  final String apellido2;
  final String sexo;
  final String direccion;
  final String telefono;
  final String email;
  final DateTime fechaNacimiento;

  Paciente({
    required this.id,
    required this.tipoId,
    required this.numeroId,
    required this.nombre1,
    required this.nombre2,
    required this.apellido1,
    required this.apellido2,
    required this.sexo,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.fechaNacimiento,
  });

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: (map['id'] ?? '').toString(),
      tipoId: (map['id_tipoid'] ?? '').toString(),
      numeroId: (map['numeroid'] ?? '').toString(),
      nombre1: (map['nombre1'] ?? '').toString(),
      nombre2: (map['nombre2'] ?? '').toString(),
      apellido1: (map['apellido1'] ?? '').toString(),
      apellido2: (map['apellido2'] ?? '').toString(),
      sexo: (map['id_sexobiologico'] ?? '').toString(),
      direccion: (map['direccion'] ?? '').toString(),
      telefono: (map['tel_movil'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      fechaNacimiento:
          map['fechanac'] != null && map['fechanac'].toString().isNotEmpty
          ? DateTime.tryParse(map['fechanac'].toString()) ??
                DateTime(1900, 1, 1)
          : DateTime(1900, 1, 1),
    );
  }
}
