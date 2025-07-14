void main() async {
  print('Inicio del programa');
  try {
    final value = await httpGet('httos://fernando-herrera.com/cursos');
    print(value);
  } catch (err) {
    print('Tenemos un error: $err');
  }
  
}

Future<String> httpGet(String url) async {
  await Future.delayed(Duration(seconds: 1));
  throw 'ERROR EN LA PETICION';
}
