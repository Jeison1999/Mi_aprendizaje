class Aprendiz {
  String? nombre;
  String? apellido;
  int? edad;

  Aprendiz({this.nombre, this.apellido, this.edad}) {}

  String? getnombre() => nombre;
  String? getapelleido() => apellido;
  int? getedad() => edad;

  @override
  String toString() {
    return 'mi nombre es $getnombre() $getapelleido() y tengo $getedad()';
  }
}

void main() {
  Aprendiz p = Aprendiz(nombre: 'jeison', edad: 10, apellido: 'ortiz');
  p.toString();
}
