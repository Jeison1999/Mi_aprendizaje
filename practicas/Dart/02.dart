void main() {
  Logistica jeison = LogisticaMaritima();
  Transporte transporte = jeison.crearTransporte();
  transporte.entregar();
}

abstract class Transporte {
  void entregar();
}

class Carro implements Transporte {
  void entregar() {
    print('entrega un carro');
  }
}

class Barco implements Transporte {
  void entregar() {
    print('entrega barco');
  }
}

class Avion implements Transporte {
  void entregar() {
    print('entrega avion');
  }
}

abstract class Logistica {
  Transporte crearTransporte();
}

class LogisticaTerrestre implements Logistica {
  Transporte crearTransporte() {
    return Carro();
  }
}

class LogisticaMaritima implements Logistica {
  Transporte crearTransporte() {
    return Barco();
  }
}

class LogisticaAerea implements Logistica {
  Transporte crearTransporte() {
    return Avion();
  }
}
