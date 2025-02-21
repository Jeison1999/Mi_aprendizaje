import 'dart:io';

void main() {
  print("ingrese un valor para declarar su renta");
  int v = int.parse(stdin.readLineSync()!);

  if (v <= 10) {
    double r = (v * 20) / 100;
    double d = v - r;
    print("su renta con el descuento es $d");
  } else if (v <= 100) {
    double r = (v * 10) / 100;
    double d = v - r;
    print("su renta con el descuento es $d");
  } else if (v <= 1000) {
    double r = (v * 5) / 100;
    double d = v - r;
    print("su renta con el descuento es $d");
  } else {
    double r = (v * 1) / 100;
    double d = v - r;
    print("su renta con el descuento es $d");

  };
}
