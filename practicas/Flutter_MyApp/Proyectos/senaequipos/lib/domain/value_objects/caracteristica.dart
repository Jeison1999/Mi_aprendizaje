class Caracteristica {
  final String value;

  Caracteristica._(this.value);

  factory Caracteristica(String input) {
    final caracteristicaLimpia = input.trim();
    if (caracteristicaLimpia.isEmpty) {
      throw ArgumentError('La característica no puede estar vacía');
    }
    return Caracteristica._(caracteristicaLimpia);
  }

  @override
  String toString() => value;
}
