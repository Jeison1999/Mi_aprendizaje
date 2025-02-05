void main() {
  Logistica logistica = Terrestre();
  Transportador transportador = logistica.crearTransportador();
  transportador.entregar();
}

abstract class Transportador {
  void entregar();
}

class Carro implements Transportador {
  @override
  void entregar() {
    print("entrega u  carro");
  }
}

class Avion implements Transportador {
  @override
  void entregar() {
    print("entregar un avion");
  }
}

class Barco implements Transportador {
  @override
  void entregar() {
    print("entregar un barco");
  }
}

abstract class Logistica {
  Transportador crearTransportador();
}

class Terrestre implements Logistica {
  @override
  Transportador crearTransportador() => Carro();
}

class mar implements Logistica {
  @override
  Transportador crearTransportador() => Barco();
}

class Aereo implements Logistica {
  @override
  Transportador crearTransportador() => Avion();
}
