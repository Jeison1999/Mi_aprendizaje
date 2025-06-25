import '../../domain/entities/registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';

class BuscarRegistroEquipo {
  final RegistroEquipoRepository repository;

  BuscarRegistroEquipo(this.repository);

  Future<RegistroEquipo?> call({
    required String cedula,
    required String serial,
  }) async {
    return await repository.buscarRegistro(cedula: cedula, serial: serial);
  }
}
