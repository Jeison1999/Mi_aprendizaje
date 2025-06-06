import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

Future<void> crearPDFUsuariosYLabor(BuildContext context) async {
  final pdf = pw.Document();

  // Obtén usuarios y sus labores
  final usuariosSnapshot = await FirebaseFirestore.instance
      .collection('usuarios')
      .get();

  // Crea una lista de filas para el PDF
  final rows = <pw.Widget>[];
  for (var usuario in usuariosSnapshot.docs) {
    final data = usuario.data();
    String laborNombre = 'Sin labor asignada';
    if (data.containsKey('laborId') && data['laborId'] != null) {
      final laborSnap = await FirebaseFirestore.instance
          .collection('labores')
          .doc(data['laborId'])
          .get();
      if (laborSnap.exists) {
        laborNombre = laborSnap['nombre'] ?? 'Sin nombre';
      }
    }
    rows.add(
      pw.Row(
        children: [
          pw.Expanded(child: pw.Text(data['nombre'] ?? '')),
          pw.Text(laborNombre),
        ],
      ),
    );
    rows.add(pw.Divider());
  }

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Usuarios y sus labores', style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 10),
          ...rows,
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
