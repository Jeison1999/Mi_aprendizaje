class SerialEquipo {
  final String value;

  SerialEquipo._(this.value);

  factory SerialEquipo(String input) {
    final serialLimpio = input.trim().toUpperCase();
    final regex = RegExp(r'^[A-Z0-9-]+$');
    if (serialLimpio.isEmpty) {
      throw ArgumentError('El serial no puede estar vacío');
    }
    if (!regex.hasMatch(serialLimpio)) {
      throw ArgumentError(
        'El serial solo puede contener letras, números y guiones',
      );
    }
    return SerialEquipo._(serialLimpio);
  }

  @override
  String toString() => value;
}
