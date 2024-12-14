class User {
  String? name;
  String? apellido;
  int? edad;

  User({this.name, this.apellido, this.edad});

  String? getNombre() => name;
  String? getApellido() => apellido;
  int? getEdad() => edad;

  @override
  String toString() =>
      'Mi nombre es ${getNombre()} ${getApellido()} y tengo ${getEdad()} años';

  void setNombre(String name) => this.name = name;
}

void main() {
  User user = User(name: 'Carlos', edad: 23, apellido: 'Ortiz');
  user.setNombre('Jeison');

  print(user.toString());
}
