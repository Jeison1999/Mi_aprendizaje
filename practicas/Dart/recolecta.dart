class Colaborador {
  String? nombreCompleto;
  int? tipoColaborador;
  double? aporte = 0;

  Colaborador({this.nombreCompleto, this.tipoColaborador, this.aporte});

  String? getNombreCompleto() => nombreCompleto;
  int? gettipoColaborador() => tipoColaborador;
  double? getaporte() => aporte;

  @override
  String toString() {
    return 'Mi nombre es ${getNombreCompleto()}, soy tipo colaborador ${gettipoColaborador()} y mi aporte es ${getaporte()}';
  }
}

class Recolecta {
  List<Colaborador> colaboradores = [];
  double? montoRecudar;
  double? balance = 0;

  Recolecta(this.montoRecudar, this.balance);

  void addColaborador(Colaborador colaborador) {
    colaboradores.add(colaborador);
    balance = balance! + colaborador.getaporte()!;
  }

  bool finalizada() => balance! >= montoRecudar!;

  List<Colaborador> Genorosos() {
    List<Colaborador> generosos = [];
    for (var i = 0; i < colaboradores.length; i++) {
      if (colaboradores[i].getaporte()! > 5000) {
        generosos.add(colaboradores[i]);
      }
    }
    return generosos;
  }
}

void main() {
  Colaborador c =
      Colaborador(nombreCompleto: 'Jeison', tipoColaborador: 1, aporte: 100.0);
  print(c.toString());
}
