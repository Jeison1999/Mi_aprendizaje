void main() {
  print('Inicio de programa');
  httpGet('httos://fernando-herrera.com/cursos').then(
    (value){
      print(value);
    })
    .catchError((err){
    print('error: $err');
  });
  print('fin del programa');
}

Future<String> httpGet(String url) {
  return Future.delayed(Duration(seconds: 1), () {
    throw 'Error en la peticion http';
  });
}
