import '../value_objects/nombre_completo.dart';
import '../value_objects/cedula.dart';
import '../value_objects/serial_equipo.dart';
import '../value_objects/caracteristica.dart';
import '../value_objects/hora_registro.dart';

class RegistroEquipo {
  final NombreCompleto nombre;
  final Cedula cedula;
  final SerialEquipo serial;
  final Caracteristica caracteristica;
  final HoraRegistro horaEntrada;
  final HoraRegistro? horaSalida;

  RegistroEquipo({
    required this.nombre,
    required this.cedula,
    required this.serial,
    required this.caracteristica,
    required this.horaEntrada,
    this.horaSalida,
  });

  RegistroEquipo actualizarHoraEntrada(DateTime nuevaHora) {
    return RegistroEquipo(
      nombre: nombre,
      cedula: cedula,
      serial: serial,
      caracteristica: caracteristica,
      horaEntrada: HoraRegistro(nuevaHora),
      horaSalida: horaSalida,
    );
  }

  RegistroEquipo registrarSalida(DateTime hora) {
    return RegistroEquipo(
      nombre: nombre,
      cedula: cedula,
      serial: serial,
      caracteristica: caracteristica,
      horaEntrada: horaEntrada,
      horaSalida: HoraRegistro(hora),
    );
  }

  @override
  String toString() =>
      'RegistroEquipo(nombre: $nombre, cedula: $cedula, serial: $serial, caracteristica: $caracteristica, horaEntrada: $horaEntrada, horaSalida: $horaSalida)';
}
