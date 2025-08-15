import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/paciente_service.dart';

class PerfilScreen extends StatefulWidget {
  final Paciente paciente;
  const PerfilScreen({super.key, required this.paciente});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late Paciente paciente;

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente;
  }

  Future<void> _actualizarDatos() async {
    final actualizado = await showDialog<Paciente>(
      context: context,
      builder: (context) => _EditarDatosDialog(paciente: paciente),
    );
    if (actualizado != null) {
      setState(() {
        paciente = actualizado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de identificación: ${paciente.tipoId}'),
                    Text('Número de identificación: ${paciente.numeroId}'),
                    Text(
                      'Nombre completo: ${paciente.nombre1} ${paciente.nombre2} ${paciente.apellido1} ${paciente.apellido2}',
                    ),
                    Text(
                      'Fecha de nacimiento: ${paciente.fechaNacimiento.toLocal().toString().split(' ')[0]}',
                    ),
                    Text('Sexo biológico: ${paciente.sexo}'),
                    Text('Dirección: ${paciente.direccion}'),
                    Text('Celular: ${paciente.telefono}'),
                    Text('Correo electrónico: ${paciente.email}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Actualizar datos'),
              onPressed: _actualizarDatos,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarDatosDialog extends StatefulWidget {
  final Paciente paciente;
  const _EditarDatosDialog({required this.paciente});

  @override
  State<_EditarDatosDialog> createState() => _EditarDatosDialogState();
}

class _EditarDatosDialogState extends State<_EditarDatosDialog> {
  late TextEditingController direccionController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  String? sexo;

  @override
  void initState() {
    super.initState();
    direccionController = TextEditingController(
      text: widget.paciente.direccion,
    );
    telefonoController = TextEditingController(text: widget.paciente.telefono);
    emailController = TextEditingController(text: widget.paciente.email);
    // Normalizar el valor inicial del sexo biológico
    final s = widget.paciente.sexo;
    if (s == 'F' || s == 'M' || s == 'O') {
      sexo = s;
    } else {
      sexo = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar datos del paciente'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: direccionController,
            decoration: const InputDecoration(labelText: 'Dirección'),
          ),
          TextField(
            controller: telefonoController,
            decoration: const InputDecoration(labelText: 'Celular'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
          ),
          DropdownButtonFormField<String>(
            value: (sexo == 'F' || sexo == 'M' || sexo == 'O') ? sexo : null,
            decoration: const InputDecoration(labelText: 'Sexo biológico'),
            items: const [
              DropdownMenuItem(value: 'F', child: Text('Femenino')),
              DropdownMenuItem(value: 'M', child: Text('Masculino')),
              DropdownMenuItem(value: 'O', child: Text('Otro')),
            ],
            onChanged: (v) => setState(() => sexo = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await PacienteService()
                  .actualizarDatosPaciente(widget.paciente.numeroId, {
                    'direccion': direccionController.text,
                    'telefono': telefonoController.text,
                    'email': emailController.text,
                    'sexo': sexo,
                  });
              final actualizado = Paciente(
                tipoId: widget.paciente.tipoId,
                numeroId: widget.paciente.numeroId,
                nombre1: widget.paciente.nombre1,
                nombre2: widget.paciente.nombre2,
                apellido1: widget.paciente.apellido1,
                apellido2: widget.paciente.apellido2,
                fechaNacimiento: widget.paciente.fechaNacimiento,
                sexo: sexo ?? widget.paciente.sexo,
                direccion: direccionController.text,
                telefono: telefonoController.text,
                email: emailController.text,
                id: '',
              );
              Navigator.pop(context, actualizado);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Datos actualizados correctamente'),
                ),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al actualizar: ' + e.toString())),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
