import 'package:get_it/get_it.dart';
import '../../application/use_cases/crear_registro_equipo.dart';
import '../../application/use_cases/actualizar_registro_equipo.dart';
import '../../application/use_cases/eliminar_registro_equipo.dart';
import '../../application/use_cases/buscar_registro_equipo.dart';
import '../../infrastructure/repositories/registro_equipo_firebase_repository.dart';
import '../../domain/repositories/registro_equipo_repository.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  // Repositorio
  sl.registerLazySingleton<RegistroEquipoRepository>(
    () => RegistroEquipoFirebaseRepository(),
  );

  // Casos de uso
  sl.registerLazySingleton(() => CrearRegistroEquipo(sl()));
  sl.registerLazySingleton(() => ActualizarRegistroEquipo(sl()));
  sl.registerLazySingleton(() => EliminarRegistroEquipo(sl()));
  sl.registerLazySingleton(() => BuscarRegistroEquipo(sl()));
}
