import 'colaborador.dart';

class Recolecta {
  List<Colaborador> _colaboradores = [];
  double? _montoRecaudar;
  double? _balance = 0;

  // constructor
  Recolecta(this._montoRecaudar, this._balance);

  //metodo para adicionar
  void addColaborador(Colaborador colaborador) {
    _colaboradores.add(colaborador);
    _balance = _balance! + colaborador.getAporte()!;
  }

  //metodo finalizada
  bool finalizada() => _balance! >= _montoRecaudar!;

  //metodo generoso
  List<Colaborador> Generosos() {
    List<Colaborador> generosos = [];
    for (int i = 0; i < _colaboradores.length; i++) {
      if (_colaboradores[i].getAporte()! > 10000) {
        generosos.add(_colaboradores[i]);
      }
    }
    return generosos;
  }

  //recaudo generos
  double recaudoGeneroso() {
    double recaudo = 0;

    for (int i = 0; i < Generosos().length; i++) {
      recaudo += Generosos()[i].getAporte()!;
    }
    return recaudo;
  }

  //promedio generosos
  double? promedioGenerosos() {
    double sumaGeneroso = 0;

    for (int i = 0; i < Generosos().length; i++) {
      sumaGeneroso += Generosos()[i].getAporte()!;
    }
    return sumaGeneroso / Generosos().length;
  }

  //Recaudo por tipo
   double recaudoPorTipo(int tipo) {
    double totaltipo = 0;

    for (int i = 0; i < _colaboradores.length; i++) {
      if (_colaboradores[i].getTipo() == tipo) {
        totaltipo = totaltipo + _colaboradores[i].getAporte()!;
      }
    }
    return totaltipo;
  }
}