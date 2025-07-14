void main() async {
  print('Inicio del programa');
  try {
    final value = await httpGet('httos://fernando-herrera.com/cursos');
    print('Exito: $value');
  } on Exception catch (err) {
    print('Tenemos un exepcion: $err');
  } catch (err) {
    print('Tenemos un error: $err');
  } finally {
    print('Fin del try y catch');
  }
}

Future<String> httpGet(String url) async {
  await Future.delayed(Duration(seconds: 1));
  throw Exception('no hay parametros en el url');
  //throw 'ERROR EN LA PETICION';
}
