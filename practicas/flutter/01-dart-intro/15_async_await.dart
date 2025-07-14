void main() {
  emitNumber()
  .listen((value) {
    print('Stream valu: $value');
  });
}

Stream emitNumber() async* {
  final valuestoEmit = [1, 2, 3, 4, 5];

  for (var i in valuestoEmit) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}
