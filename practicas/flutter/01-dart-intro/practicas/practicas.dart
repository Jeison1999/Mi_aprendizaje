void main() {
  final car1 = Car.fromJson({
    'modelo': 'Civic',
    'marca': 'Honda',
    'year': 2020,
  });

  print(car1);

  final car2 = Car(modelo: 'Corolla', marca: 'Toyota', year: 2021);
  car2.year = 2022;
  print(car2);
}

class Car {
  String? modelo;
  String? marca;
  int? year;

  Car({this.modelo, this.marca, this.year});

  Car.fromJson(Map<String, dynamic> CarJson)
    : modelo = CarJson['modelo'],
      marca = CarJson['marca'],
      year = CarJson['year'];
  @override
  String toString() {
    return 'Car(modelo: $modelo, marca: $marca, year: $year)';
  }
}
