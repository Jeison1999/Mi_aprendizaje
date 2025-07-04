import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  aprendiz,
  instructor,
  administrativo,
  teo,
  contratista,
  visitante,
  otro,
}

class AppUser {
  final String id;
  final String nombre;
  final String cedula;
  final String celular;
  final String correo;
  final UserRole rol;
  final String? otroTipo;

  AppUser({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.celular,
    required this.correo,
    required this.rol,
    this.otroTipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'celular': celular,
      'correo': correo,
      'rol': rol.name,
      'otroTipo': otroTipo,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      nombre: map['nombre'] ?? '',
      cedula: map['cedula'] ?? '',
      celular: map['celular'] ?? '',
      correo: map['correo'] ?? '',
      rol: UserRole.values.firstWhere(
        (e) => e.name == map['rol'],
        orElse: () => UserRole.otro,
      ),
      otroTipo: map['otroTipo'],
    );
  }
}
