class HoraRegistro {
  final DateTime value;

  HoraRegistro._(this.value);

  factory HoraRegistro([DateTime? input]) {
    return HoraRegistro._(input ?? DateTime.now());
  }

  @override
  String toString() => value.toIso8601String();
}
