class Resultado {
  final String id;
  final DateTime fecha;
  final String idOrden;
  final String idProcedimiento;
  final String idPrueba;
  final String idPruebaOpcion;
  final String resOpcion;
  final num resNumerico;
  final String resTexto;
  final String resMemo;
  final int numProcesamientos;

  Resultado({
    required this.id,
    required this.fecha,
    required this.idOrden,
    required this.idProcedimiento,
    required this.idPrueba,
    required this.idPruebaOpcion,
    required this.resOpcion,
    required this.resNumerico,
    required this.resTexto,
    required this.resMemo,
    required this.numProcesamientos,
  });

  factory Resultado.fromMap(Map<String, dynamic> map) {
    return Resultado(
      id: map['id'],
      fecha: DateTime.parse(map['fecha']),
      idOrden: map['id_orden'],
      idProcedimiento: map['id_procedimiento'],
      idPrueba: map['id_prueba'],
      idPruebaOpcion: map['id_pruebaopcion'],
      resOpcion: map['res_opcion'],
      resNumerico: map['res_numerico'],
      resTexto: map['res_texto'],
      resMemo: map['res_memo'],
      numProcesamientos: map['num_procesamientos'],
    );
  }
}
