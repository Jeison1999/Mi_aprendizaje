class Colaborador {
  String? _nombreCompleto;
  int? _tipoColaborador;
  double? _aporte = 0;

  //constructor
  Colaborador(this._nombreCompleto, this._aporte, this._tipoColaborador);

  String? getNombreCompleto() => _nombreCompleto;
  double? getAporte() => _aporte;
  int? getTipo() => _tipoColaborador;

  @override
  String toString() {
    return '{"Nombre: $_nombreCompleto, Tipo: $_tipoColaborador, Aporte: $_aporte}';
  }
}

