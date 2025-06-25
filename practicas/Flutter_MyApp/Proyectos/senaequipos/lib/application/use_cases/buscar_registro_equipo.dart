import '../../domain/entities/registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';

class BuscarRegistroEquipo {
  final RegistroEquipoRepository repository;

  BuscarRegistroEquipo(this.repository);

  Future<RegistroEquipo?> call({
    required String cedula,
    required String serial,
  }) async {
    if (serial.isEmpty) {
      // Buscar el primer registro con esa cédula
      final todos = await repository.listarRegistros();
      try {
        return todos.firstWhere(
          (r) => r.cedula.value == cedula,
        );
      } catch (e) {
        return null;
      }
    } else {
      return await repository.buscarRegistro(cedula: cedula, serial: serial);
    }
  }
}
