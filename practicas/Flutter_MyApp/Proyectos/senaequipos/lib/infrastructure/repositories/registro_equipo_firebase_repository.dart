import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/registro_equipo.dart';
import '../../domain/repositories/registro_equipo_repository.dart';
import '../../domain/value_objects/nombre_completo.dart';
import '../../domain/value_objects/cedula.dart';
import '../../domain/value_objects/serial_equipo.dart';
import '../../domain/value_objects/caracteristica.dart';
import '../../domain/value_objects/hora_registro.dart';

class RegistroEquipoFirebaseRepository implements RegistroEquipoRepository {
  final _collection = FirebaseFirestore.instance.collection(
    'registros_equipos',
  );

  @override
  Future<void> crearRegistro(RegistroEquipo registro) async {
    final docId = _docId(registro.cedula, registro.serial);
    await _collection.doc(docId).set(_toMap(registro));
  }

  @override
  Future<void> actualizarRegistro(RegistroEquipo registro) async {
    final docId = _docId(registro.cedula, registro.serial);
    await _collection.doc(docId).update(_toMap(registro));
  }

  @override
  Future<void> eliminarRegistro({
    required String cedula,
    required String serial,
  }) async {
    final docId = _docId(Cedula(cedula), SerialEquipo(serial));
    await _collection.doc(docId).delete();
  }

  @override
  Future<RegistroEquipo?> buscarRegistro({
    required String cedula,
    required String serial,
  }) async {
    final docId = _docId(Cedula(cedula), SerialEquipo(serial));
    final doc = await _collection.doc(docId).get();
    if (!doc.exists) return null;
    return _fromMap(doc.data()!);
  }

  @override
  Future<List<RegistroEquipo>> listarRegistros() async {
    final query = await _collection.get();
    // Filtrar registros con nombre vacío o nulo para evitar errores
    final docs = query.docs.where((doc) {
      final data = doc.data();
      return data['nombre'] != null &&
          (data['nombre'] as String).trim().isNotEmpty;
    });
    return docs.map((doc) => _fromMap(doc.data())).toList();
  }

  // Utilidades
  String _docId(Cedula cedula, SerialEquipo serial) =>
      '${cedula.value}_${serial.value}';

  Map<String, dynamic> _toMap(RegistroEquipo r) => {
    'nombre': r.nombre.value,
    'cedula': r.cedula.value,
    'serial': r.serial.value,
    'caracteristica': r.caracteristica.value,
    'horaEntrada': r.horaEntrada.value.toIso8601String(),
    'horaSalida': r.horaSalida?.value.toIso8601String(),
  };

  RegistroEquipo _fromMap(Map<String, dynamic> map) => RegistroEquipo(
    nombre: NombreCompleto(map['nombre'] ?? ''),
    cedula: Cedula(map['cedula'] ?? ''),
    serial: SerialEquipo(map['serial'] ?? ''),
    caracteristica: Caracteristica(map['caracteristica'] ?? ''),
    horaEntrada: HoraRegistro(DateTime.parse(map['horaEntrada'])),
    horaSalida: map['horaSalida'] != null
        ? HoraRegistro(DateTime.parse(map['horaSalida']))
        : null,
  );
}
