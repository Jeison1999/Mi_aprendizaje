import 'package:flutter/material.dart';

class SerialTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final Future<String?> Function()? onScan;
  final BuildContext context;

  const SerialTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.onScan,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.confirmation_number_rounded),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner_rounded),
          tooltip: 'Escanear código',
          onPressed: onScan,
        ),
      ),
      validator: validator,
    );
  }
}
