import '../../domain/repositories/registro_equipo_repository.dart';

class EliminarRegistroEquipo {
  final RegistroEquipoRepository repository;

  EliminarRegistroEquipo(this.repository);

  Future<void> call({required String cedula, required String serial}) async {
    await repository.eliminarRegistro(cedula: cedula, serial: serial);
  }
}
