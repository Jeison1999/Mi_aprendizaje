void main() {
  final String pokemon = 'Ditto';
  final int hp = 100;
  final bool isalive = true;
  final List<String> habilities = ['impostor'];
  final sprites = <String>['dart', 'flutter'];

  //dynamic == null
  dynamic errorMessage = 'hola';
  errorMessage = true;
  errorMessage = [1, 2, 3, 4, 5];
  errorMessage = {1, 2, 3, 4, 5};
  errorMessage = () => true;
  errorMessage = null;
  
  print(""" 
  $pokemon
  $hp
  $isalive
  $habilities
  $sprites
  $errorMessage
  """);
}
