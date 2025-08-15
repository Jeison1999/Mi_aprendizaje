import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/resultado.dart';

class ResultadoService {
  Future<void> crearResultadosDePrueba(String idOrden) async {
    final procedimientos = ['Química sanguínea', 'Hematología', 'Urianálisis'];
    final pruebasPorProcedimiento = {
      'Química sanguínea': ['Glucometría', 'Hierro total', 'Triglicéridos'],
      'Hematología': ['Hemoglobina', 'Leucocitos'],
      'Urianálisis': ['Proteínas', 'Glucosa'],
    };
    int idx = 1;
    for (final proc in procedimientos) {
      for (final prueba in pruebasPorProcedimiento[proc]!) {
        await _resultados.add({
          'id_orden': idOrden,
          'id_procedimiento': proc,
          'id_prueba': prueba,
          'id_pruebaopcion': 'opcion$idx',
          'res_opcion': 'Normal',
          'res_numerico': 70 + idx,
          'res_texto': 'Valor dentro del rango',
          'res_memo': '',
          'num_procesamientos': 1,
          'fecha': DateTime.now().toIso8601String(),
        });
        idx++;
      }
    }
  }

  final CollectionReference _resultados = FirebaseFirestore.instance.collection(
    'resultados',
  );

  Future<List<Resultado>> getResultadosPorOrden(String idOrden) async {
    final query = await _resultados.where('id_orden', isEqualTo: idOrden).get();
    return query.docs
        .map((doc) => Resultado.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
