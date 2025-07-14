void main() {
  print(greetEveryone());
  print('suma: ${addTwoNumbers(10, 20)}');
  print(greetperson(name: 'jeison', message: 'hi'));
}

String greetEveryone() => 'hello everyone!';

int addTwoNumbers(int a, int b) => a + b;

int addTwoNumbersOptional(int a, [int b = 0]) {
  //b ??= 0;
  return a + b;
}

String greetperson({required String name, String message = 'hola'}) {
  return '$message, jeison';
}
