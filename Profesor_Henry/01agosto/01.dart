class Calculadora {
  double num1 = 0;
  double num2 = 0;
  String? operacion;

  Calculadora(double num1, double num2, String operacion) {
    this.num1 = num1;
    this.num2 = num2;
    this.operacion = operacion;
  }

  double sumar() {
    double suma = num1 + num2;
    return suma;
  }

  double restar() {
    double resta = num1 - num2;
    return resta;
  }

  double multiplicar() {
    double mul = num1 * num2;
    return mul;
  }

  double dividir() {
    double div = num1 / num2;
    return div;
  }

  void calcular() {
    if (operacion == "S") {
      print(sumar());
    } else if (operacion == "R") {
      print(restar());
    } else if (operacion == "M") {
      print(multiplicar());
    } else if (operacion == "D") {
      print(dividir());
    }
  }
}

void main(){

  Calculadora calcu = new Calculadora(2, 2, "D");

  calcu.calcular();
  
}