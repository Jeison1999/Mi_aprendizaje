import 'dart:io';

class Tema {
  String? name;
  int? edad;
}

class Nino extends Tema {}

class adulto extends Tema {}

class viejo extends Tema {}

void main() {
  print('ingrese su nombre');
  String? name = stdin.readLineSync();

  print('ingrese su edad');
  int? edad = int.parse(stdin.readLineSync()!);

  if (edad < 12 && edad > 0) {
    print("eres un niño $name");
  } else if (edad > 12 && edad < 17) {
    print("eres un adolescente $name");
  } else if (edad > 18 && edad < 64) {
    print("eres un adulto $name");
  } else if (edad > 65) {
    print("eres un viejo $name");
  }
}
