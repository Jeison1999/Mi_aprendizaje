class Usuario {
  String? nombre;
  String? apellido;
  int? edad;

  Usuario({this.nombre, this.apellido, this.edad});

  String? getnombre() => nombre;
  String? getapellido() => apellido;
  int? getedad() => edad;

  @override
  String toString() =>
      'mi nombre es ${getnombre()} ${getapellido()} tengo ${getedad()}';

  void setnombre(String nombre) => this.nombre = nombre;
}

void main() {
  Usuario p = Usuario(nombre: 'jeison', edad: 10, apellido: 'ortiz');

  p.setnombre('carlos');
  print(p.toString());
}
