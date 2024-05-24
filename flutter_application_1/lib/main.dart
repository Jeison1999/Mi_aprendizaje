import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escudo Real Madrid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Escudo Real Madrid'),
        ),
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: RealMadridShieldPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class RealMadridShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // Draw crown
    final crownPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Path crownPath = Path();
    crownPath.moveTo(size.width / 2 - 25, size.height / 2 - 40);
    crownPath.lineTo(size.width / 2, size.height / 2 - 100);
    crownPath.lineTo(size.width / 2 + 25, size.height / 2 - 40);
    crownPath.lineTo(size.width / 2 - 25, size.height / 2 - 40);
    crownPath.close();

    canvas.drawPath(crownPath, crownPaint);

    // Draw cross
    final crossPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Path crossPath = Path();
    crossPath.moveTo(size.width / 2 - 15, size.height / 2 + 50);
    crossPath.lineTo(size.width / 2 + 15, size.height / 2 + 50);
    crossPath.lineTo(size.width / 2 + 15, size.height / 2 - 50);
    crossPath.lineTo(size.width / 2 - 15, size.height / 2 - 50);
    crossPath.lineTo(size.width / 2 - 15, size.height / 2 + 50);
    crossPath.moveTo(size.width / 2 - 50, size.height / 2 - 15);
    crossPath.lineTo(size.width / 2 + 50, size.height / 2 - 15);
    crossPath.lineTo(size.width / 2 + 50, size.height / 2 + 15);
    crossPath.lineTo(size.width / 2 - 50, size.height / 2 + 15);
    crossPath.lineTo(size.width / 2 - 50, size.height / 2 - 15);

    canvas.drawPath(crossPath, crossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
