import 'package:flutter/material.dart';
import '../services/paciente_service.dart';
import '../models/paciente.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late int _captchaA;
  late int _captchaB;
  final TextEditingController _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generarCaptcha();
  }

  void _generarCaptcha() {
    _captchaA = 1 + (DateTime.now().millisecondsSinceEpoch % 9);
    _captchaB = 1 + ((DateTime.now().millisecondsSinceEpoch ~/ 1000) % 9);
    _captchaController.clear();
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  String? _tipoId;
  bool _loading = false;
  String? _error;

  final List<Map<String, String>> tiposId = [
    {'value': 'CC', 'label': 'Cédula de ciudadanía'},
    {'value': 'TI', 'label': 'Tarjeta de identidad'},
    {'value': 'CE', 'label': 'Cédula de extranjería'},
    {'value': 'PA', 'label': 'Pasaporte'},
  ];

  Future<void> _loginORegistro() async {
    if (!_formKey.currentState!.validate()) return;
    if (_captchaController.text.trim() != (_captchaA + _captchaB).toString()) {
      setState(() {
        _error = 'CAPTCHA incorrecto. Por favor resuelve la suma.';
      });
      _generarCaptcha();
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final service = PacienteService();
    final tipoId = _tipoId;
    final numeroId = _documentController.text.trim();
    final fechaNac = _fechaController.text.trim();
    // Validación de longitud mínima
    if (numeroId.length < 6) {
      setState(() {
        _loading = false;
        _error = 'El número de identificación debe tener al menos 6 dígitos.';
      });
      return;
    }
    // Buscar paciente por tipo y número de documento
    final paciente = await service.getPacientePorDocumento(numeroId);
    if (paciente != null && paciente.tipoId == tipoId) {
      setState(() {
        _loading = false;
        _error = null;
      });
      Navigator.pushNamed(context, '/home', arguments: paciente);
    } else if (paciente == null) {
      setState(() {
        _loading = false;
      });
      final registro = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => _RegistroDialog(
          tipoId: tipoId!,
          numeroId: numeroId,
          fechaNac: fechaNac,
        ),
      );
      if (registro != null) {
        setState(() {
          _loading = true;
        });
        await service.guardarPaciente(registro);
        final nuevoPaciente = await service.getPacientePorDocumento(numeroId);
        setState(() {
          _loading = false;
        });
        if (nuevoPaciente != null && nuevoPaciente.tipoId == tipoId) {
          Navigator.pushNamed(context, '/perfil', arguments: nuevoPaciente);
        } else {
          setState(() {
            _error = 'Error al registrar el paciente.';
          });
        }
      }
    } else {
      setState(() {
        _loading = false;
        _error = 'El tipo de documento no coincide con el número ingresado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _tipoId,
                decoration: const InputDecoration(
                  labelText: 'Tipo de documento',
                ),
                items: tiposId
                    .map(
                      (tipo) => DropdownMenuItem<String>(
                        value: tipo['value'],
                        child: Text(tipo['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoId = value;
                  });
                },
                validator: (v) =>
                    v == null ? 'Seleccione un tipo de documento' : null,
              ),
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(
                  labelText: 'Número de documento',
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de nacimiento (YYYY-MM-DD)',
                ),
                keyboardType: TextInputType.datetime,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('$_captchaA + $_captchaB = '),
                  Expanded(
                    child: TextFormField(
                      controller: _captchaController,
                      decoration: const InputDecoration(
                        labelText: 'Resuelve el CAPTCHA',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Campo requerido' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _generarCaptcha,
                  ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _loginORegistro,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegistroDialog extends StatefulWidget {
  final String tipoId;
  final String numeroId;
  final String fechaNac;
  const _RegistroDialog({
    required this.tipoId,
    required this.numeroId,
    required this.fechaNac,
  });

  @override
  State<_RegistroDialog> createState() => _RegistroDialogState();
}

class _RegistroDialogState extends State<_RegistroDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombre1Controller = TextEditingController();
  final TextEditingController _apellido1Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _sexo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registro de paciente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tipo: ${widget.tipoId}'),
              Text('Número: ${widget.numeroId}'),
              Text('Fecha nacimiento: ${widget.fechaNac}'),
              TextFormField(
                controller: _nombre1Controller,
                decoration: const InputDecoration(labelText: 'Primer nombre'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _apellido1Controller,
                decoration: const InputDecoration(labelText: 'Primer apellido'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo biológico'),
                items: const [
                  DropdownMenuItem(value: 'F', child: Text('Femenino')),
                  DropdownMenuItem(value: 'M', child: Text('Masculino')),
                  DropdownMenuItem(value: 'O', child: Text('Otro')),
                ],
                onChanged: (v) => setState(() => _sexo = v),
                validator: (v) =>
                    v == null ? 'Seleccione el sexo biológico' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'id_tipoid': widget.tipoId,
                'numeroid': widget.numeroId,
                'fechanac': widget.fechaNac,
                'nombre1': _nombre1Controller.text,
                'apellido1': _apellido1Controller.text,
                'email': _emailController.text,
                'sexo': _sexo,
              });
            }
          },
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
