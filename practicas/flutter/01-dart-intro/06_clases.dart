void main() {
  final wolverine = Hero(power: 'regeneacion', name: 'Logan');
  print(wolverine);
  print(wolverine.name);
  print(wolverine.power);
}

class Hero {
  String? name;
  String? power;

  Hero({this.name, this.power = 'sin power'});

  @override
  String toString() => '$name - $power';
}
