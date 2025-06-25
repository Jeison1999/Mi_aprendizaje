import '../entities/registro_equipo.dart';

abstract class RegistroEquipoRepository {
  Future<void> crearRegistro(RegistroEquipo registro);
  Future<void> actualizarRegistro(RegistroEquipo registro);
  Future<void> eliminarRegistro({
    required String cedula,
    required String serial,
  });
  Future<RegistroEquipo?> buscarRegistro({
    required String cedula,
    required String serial,
  });
  Future<List<RegistroEquipo>> listarRegistros();
}
