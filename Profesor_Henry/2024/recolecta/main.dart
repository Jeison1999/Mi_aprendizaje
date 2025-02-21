import 'dart:io';
import 'colaborador.dart';
import 'Recolecta.dart';

void main() {
  print('/////////BIENVENIDOS AL SISTEMA DE RECOLETA////////////');
  print('Por favor, Ingrese la cantidad de dinero a recoletar:');
  double b = double.parse(stdin.readLineSync()!);

  Recolecta r = Recolecta(b, 0.0);

  while (!r.finalizada()) {
    print('Ingrese su nombre:');
    String nombre = stdin.readLineSync()!;
    print('Valor a aportar:');
    double aporte = double.parse(stdin.readLineSync()!);
    print('Tipo  1 (Aprendiz) ó 2 (Instructor):');
    int tipo = int.parse(stdin.readLineSync()!);
    if (aporte == 0) {
      print('tas pelao que?');
    } else {
      print('Gracias por su aporte');
    }
      
    Colaborador c = Colaborador(nombre, aporte, tipo);
    r.addColaborador(c);
  }
  print('valor Total Recolectado por los generosos: ${r.recaudoGeneroso()}');
  print('valor Total recolectador por los aprendices: ${r.recaudoPorTipo(1)}');
  print('valor Total recolectador por los instructores: ${r.recaudoPorTipo(2)}');
}
  

