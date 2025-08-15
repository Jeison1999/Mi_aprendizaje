import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/paciente.dart';

class PacienteService {
  Future<void> actualizarDatosPaciente(
    String numeroId,
    Map<String, dynamic> nuevosDatos,
  ) async {
    final query = await _pacientes
        .where('numeroid', isEqualTo: numeroId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update(nuevosDatos);
    } else {
      throw Exception('Paciente no encontrado');
    }
  }

  final CollectionReference _pacientes = FirebaseFirestore.instance.collection(
    'pacientes',
  );

  Future<Paciente?> getPacientePorDocumento(String numeroId) async {
    final query = await _pacientes
        .where('numeroid', isEqualTo: numeroId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return Paciente.fromMap(query.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> guardarPaciente(Map<String, dynamic> data) async {
    await _pacientes.add(data);
  }
}
