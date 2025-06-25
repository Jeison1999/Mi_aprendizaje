import '../../domain/entities/registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';

class ActualizarRegistroEquipo {
  final RegistroEquipoRepository repository;

  ActualizarRegistroEquipo(this.repository);

  Future<void> call(RegistroEquipo registro) async {
    await repository.actualizarRegistro(registro);
  }
}
