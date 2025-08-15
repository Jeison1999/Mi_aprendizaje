import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/orden.dart';

class OrdenService {
  Future<void> crearOrdenesDePrueba(String idDocumento) async {
    for (int i = 1; i <= 10; i++) {
      await _ordenes.add({
        'id_documento': idDocumento,
        'orden': 'ORD-${i.toString().padLeft(3, '0')}',
        'fecha': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
        'id_historia': 'HIST-${i.toString().padLeft(3, '0')}',
        'id_profesional_ordena': 'PROF-${i.toString().padLeft(3, '0')}',
        'profesional_externo': false,
      });
    }
  }

  final CollectionReference _ordenes = FirebaseFirestore.instance.collection(
    'ordenes',
  );

  Future<List<Orden>> getOrdenesPorPaciente(String idDocumento) async {
    final query = await _ordenes
        .where('id_documento', isEqualTo: idDocumento)
        .get();
    return query.docs
        .map((doc) => Orden.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
