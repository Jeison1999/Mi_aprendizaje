void main() {
  final Map<String, dynamic> rawJson = {
    'name': 'tony stark',
    'power': 'money',
    'isAlive': true
  };

  final ironman = Hero.fromJson(rawJson);


  //final ironman = Hero(isAlive: false, power: 'Money', name: 'Tony Stark');

  print(ironman);
}

class Hero {
  String? name;
  String? power;
  bool? isAlive;

  Hero({this.name, this.power, this.isAlive});

  Hero.fromJson(Map<String, dynamic> json)
    : name = json['name'] ?? 'no name found',
      power = json['power'] ?? 'no power found',
      isAlive = json['isAlive'] ?? 'no alive found';

  @override
  String toString() => '$name, $power, isAlive ${isAlive! ? 'yes' : 'nope'}';
}
