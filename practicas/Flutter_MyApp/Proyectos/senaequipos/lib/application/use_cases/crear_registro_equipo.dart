import '../../domain/entities/registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';

class CrearRegistroEquipo {
  final RegistroEquipoRepository repository;

  CrearRegistroEquipo(this.repository);

  Future<void> call(RegistroEquipo registro) async {
    // Aquí podrías agregar lógica de negocio extra si es necesario
    await repository.crearRegistro(registro);
  }
}
