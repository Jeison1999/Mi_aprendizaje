// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';

// Future<void> crearPDF(
//   BuildContext context,
//   List<String> nombres,
//   List<String?> seleccionados,
// ) async {
//   // Solicitar permiso de almacenamiento para Android 11+
//   if (Platform.isAndroid) {
//     var status = await Permission.manageExternalStorage.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Permiso de almacenamiento denegado')),
//       );
//       return;
//     }
//   }

//   final pdf = pw.Document();
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           children: [
//             pw.Text('Formulario de Selecciones', style: pw.TextStyle(fontSize: 24)),
//             pw.SizedBox(height: 20),
//             ...List.generate(nombres.length, (i) {
//               return pw.Text(
//                 '${nombres[i]}: ${seleccionados[i] ?? "Sin selección"}',
//                 style: pw.TextStyle(fontSize: 16),
//               );
//             }),
//           ],
//         );
//       },
//     ),
//   );

//   Directory? downloadsDir;
//   if (Platform.isAndroid) {
//     final downloadsPath = "/storage/emulated/0/Download";
//     downloadsDir = Directory(downloadsPath);
//   } else {
//     downloadsDir = await getApplicationDocumentsDirectory();
//   }

//   final file = File("${downloadsDir.path}/formulario.pdf");
//   await file.writeAsBytes(await pdf.save());

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('PDF guardado en: ${file.path}')),
//   );
// }

