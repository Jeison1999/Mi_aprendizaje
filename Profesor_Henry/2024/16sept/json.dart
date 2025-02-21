import 'dart:convert';

class Colaborador {
  String? nombreCompleto;
  int? tipoColaborador;
  double? aporte;

  Colaborador(String c) {
    Map<String, dynamic> map = jsonDecode(c);
    this.nombreCompleto = map["nombreCompleto"];
    this.tipoColaborador = map["tipoColaborador"];
    this.aporte = map["aporte"];
  }
}

void main() {
  String c =
      '{"nombreCompleto": "jeisonOrtiz", "tipoColaborador": 2, "aporte": 1000.0}';
  Colaborador colaborador = Colaborador(c);

  print(colaborador.nombreCompleto);
  print(colaborador.tipoColaborador);
  print(colaborador.aporte);
}
