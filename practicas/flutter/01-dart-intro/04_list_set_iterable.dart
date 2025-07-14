void main() {
  final numbers = [1, 2, 3, 4, 5, 5, 5, 6, 7, 8, 9, 9, 10];

  print('List original: $numbers');
  // longitud de la lista
  print('Length: ${numbers.length}');
  // valor de la posicion 1
  print('index 0: ${numbers[0]}');
  // valor de la primera posicion
  print('First: $numbers.first');
  // valor de la ultima posicion
  print('Last: ${numbers.last}');
  //los valores de la lista en reversa
  print('reverse: ${numbers.reversed}');

  final reversedNumbers = numbers.reversed;
  print('iterable: ${reversedNumbers}');
  print('List: $reversedNumbers.toList()');
  print('set: ${reversedNumbers.toSet()}');

  final numbersGreaterThan5 = numbers.where((num) => num > 5);

  print('>5 iterable: $numbersGreaterThan5');
  print('>5 set ${numbersGreaterThan5.toSet()}');
}
