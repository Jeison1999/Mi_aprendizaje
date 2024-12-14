void main() {}

abstract class Transporte {
  void entrega();
}

class carro implements Transporte {
  @override
  void entrega() => print('entrega un carro');
}

class Barco implements Transporte {
  @override
  void entrega() => print('entrega un Barco');
}

class Avion implements Transporte {
  @override
  void entrega() => print('entrega un Avion');
}

abstract class Logistica {
  Transporte crearTransporte();
}

class LogisticaTerrestre implements Logistica {
  @override
  Transporte crearTransporte() => carro();
}
