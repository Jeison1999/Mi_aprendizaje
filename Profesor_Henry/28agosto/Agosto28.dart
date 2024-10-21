void main() {
  Particular car = Particular(2000);
  car.ciudad = 'bogota';
  car.placa = 'dfg34f';
  car.color = 'rojo';
  print(
      'Particular: ${car.getInfo()} - ${car.placa} - ${car.color} - ${car.getRtm()}');

  Publico carro = Publico(977);
  carro.ciudad = 'mexico';
  carro.ruta = '123';
  carro.empresa = 'sobusa';
  print('Publico: ${carro.getInfo()} - ${carro.getCodigo()}');
}

class Trasnporte {
  String? empresa;
  String? ciudad;
  String getInfo() {
    return '$empresa - $ciudad';
  }
}

class Particular extends Trasnporte {
  String? placa;
  String? color;
  int? modelo;

  Particular(this.modelo);

  @override
  String getInfo() {
    return ciudad!;
  }

  int getRtm() {
    return modelo! + 5;
  }
}

class Publico extends Trasnporte {
  int _ninterno;
  String? ruta;
  String? placa;

  Publico(this._ninterno);

  String getCodigo() {
    return '$ruta - $_ninterno';
  }
}
