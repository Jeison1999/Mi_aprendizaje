class Transporte {
  String? marca;
}

class Terrestre extends Transporte{ 
  int? llantas;
}

 class Aereo extends Transporte {
  int? motores;
 }

 class Auto extends Terrestre {
  bool? aire;
 }

 class Moto extends Terrestre {
  int? cascos;
 }

 class Avion extends Aereo {
  static void manual() {
    print("Hola mundo!");
  }
 }

void main (){
  Moto moto = new Moto();
  moto.cascos = 2;
  moto.llantas = 2;
  moto.marca = "ducati";

  Auto auto = new Auto();
  auto.aire = true;
  auto.llantas = 4;
  auto.marca = "mazda";

  Avion avion = new Avion();
  avion.motores = 4;
  avion.marca = "jet";
 

  print("la moto ${moto.marca}, tiene ${moto.cascos} cascos y ${moto.llantas} llantas");
  print(" el auto ${auto.marca} con ${auto.llantas} llantas tiene aire? ${auto.aire}");
  print("el avion ${avion.marca} tiene ${avion.motores} motores  ");

  Avion.manual();

}