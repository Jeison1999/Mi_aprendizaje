import 'package:flutter/material.dart';

const List<Color> _colorsTheme = [
  Colors.blue,
  Colors.black,
  Colors.white,
  Colors.yellow,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
    : assert(
        selectedColor >= 0 && selectedColor <= _colorsTheme.length - 1,
        'Los colores van del 0 al ${_colorsTheme.length}',
      );

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorsTheme[selectedColor],
      // brightness: Brightness.dark,//fondo oscuro
    );
  }
}
