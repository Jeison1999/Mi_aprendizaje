import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

Future<void> crearPDFUsuariosYLabor(BuildContext context) async {
  final pdf = pw.Document();

  // Carga la imagen desde assets
  final imageBytes = await rootBundle.load('assets/KFC.png');
  final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

  // Obtén usuarios y sus labores
  final usuariosSnapshot = await FirebaseFirestore.instance
      .collection('usuarios')
      .get();

  // Prepara los datos para la tabla
  final List<List<String>> data = [
    ['Nombre', 'Labor asignada'],
  ];

  for (var usuario in usuariosSnapshot.docs) {
    final userData = usuario.data();
    String laborNombre = 'Sin labor asignada';
    if (userData.containsKey('laborId') && userData['laborId'] != null) {
      final laborSnap = await FirebaseFirestore.instance
          .collection('labores')
          .doc(userData['laborId'])
          .get();
      if (laborSnap.exists) {
        laborNombre = laborSnap['nombre'] ?? 'Sin nombre';
      }
    }
    data.add([userData['nombre'] ?? '', laborNombre]);
  }

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(child: pw.Image(image, width: 180, height: 180)),
          pw.SizedBox(height: 16),
          // ignore: deprecated_member_use
          pw.Table.fromTextArray(
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(0xFFD8001D),
              fontSize: 14,
            ),
            cellStyle: pw.TextStyle(fontSize: 15),
            data: data,
          ),
        ],
      ),
    ),
  );

  // Guarda el PDF en Descargas (Android)
  final downloadsDir = Directory('/storage/emulated/0/Download');
  final file = File('${downloadsDir.path}/usuarios_labores.pdf');
  await file.writeAsBytes(await pdf.save());

  // Notifica al usuario
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('PDF generado en Descargas')));
}
