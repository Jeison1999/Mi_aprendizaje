Stream<int> generadordenumeros(int n) async* {
  for (int i = 0; i < n; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

Future<int> sumadenumeros(Stream<int> stream) async {
  int suma = 0;
  await for (var value in stream) {
    suma += value;
  }
  return suma;
}

void main() async {
  Stream<int> tepo = generadordenumeros(10);
  int flepo = await sumadenumeros(tepo);  
  print(flepo);
}
