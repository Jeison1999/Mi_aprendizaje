void main() {
  Logistica logistica = logisticaTerrestre();
  Transporte transporte = logistica.crearTransporte();
  transporte.entrega();
}

abstract class Transporte {
  void entrega();
}

class Carro implements Transporte {
  @override
  void entrega() {
    print('Entrega realizada por carro');
  }
}

class Barco implements Transporte {
  @override
  void entrega() {
    print('Entrega realizada por barco');
  }
}

class Avion implements Transporte {
  @override
  void entrega() {
    print('Entrega realizada por avion');
  }
}

abstract class Logistica {
  Transporte crearTransporte();
}

class logisticaTerrestre implements Logistica {
  @override
  Transporte crearTransporte() {
    return Carro();
  }
}

class logisticaMaritima implements Logistica {
  @override
  Transporte crearTransporte() {
    return Barco();
  }
}

class logisticaAerea implements Logistica {
  @override
  Transporte crearTransporte() {
    return Avion();
  }
}
