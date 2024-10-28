import 'dart:io';

// Clase SumaNumeros
class SumaNumeros {
  int cantidad; // Atributo para almacenar la cantidad de números a sumar

  // Constructor para inicializar la cantidad de números
  SumaNumeros(this.cantidad);

  // Método para realizar la suma de los números
  int sumar() {
    int suma = 0;

    for (int i = 1; i <= cantidad; i++) {
      stdout.write('Ingresa el número $i: ');
      int numero = int.parse(stdin.readLineSync()!);
      suma += numero;
    }

    return suma;
  }
}

void main() {
  // Solicitar la cantidad de números al usuario
  stdout.write('¿Cuántos números deseas sumar?: ');
  int cantidad = int.parse(stdin.readLineSync()!);

  // Crear una instancia de la clase SumaNumeros
  SumaNumeros sumaNumeros = SumaNumeros(cantidad);

  // Llamar al método sumar para obtener el resultado
  int resultado = sumaNumeros.sumar();

  // Mostrar el resultado
  print('La suma de los $cantidad números es: $resultado');
}
