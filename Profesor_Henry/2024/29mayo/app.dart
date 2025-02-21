import 'dart:io';

void main() {
  print("ingrese un numero entero");
  int i = int.parse(stdin.readLineSync()!);

  if (i > 0) {
    print(" $i es un numero positivo");
  } else {
    if (i < 0) {
      print(" $i es un numero negativo");
    } else {
      print(" su numero es cero");
    }
  }
}
