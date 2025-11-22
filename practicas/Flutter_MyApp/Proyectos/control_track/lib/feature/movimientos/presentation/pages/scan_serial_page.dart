import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanSerialPage extends StatefulWidget {
  const ScanSerialPage({super.key});

  @override
  State<ScanSerialPage> createState() => _ScanSerialPageState();
}

class _ScanSerialPageState extends State<ScanSerialPage> {
  String? _code;
  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      setState(() {
        _scanned = true;
      });
      Navigator.of(context).pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear serial/código')),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          if (_scanned) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
