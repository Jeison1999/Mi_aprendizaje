import 'package:flutter/material.dart';
import 'package:zona44_flutter/screens/home_cliente.dart';
import 'package:zona44_flutter/screens/login_screen.dart';
import 'package:zona44_flutter/screens/panel_admin.dart';
import 'package:zona44_flutter/services/api_service.dart';

class VerificarSesion extends StatefulWidget {
  const VerificarSesion({super.key});

  @override
  _VerificarSesionState createState() => _VerificarSesionState();
}

class _VerificarSesionState extends State<VerificarSesion> {
  @override
  void initState() {
    super.initState();
    verificar();
  }

  void verificar() async {
    final usuario = await ApiService.getPerfil();

    if (usuario == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else if (usuario['rol'] == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PanelAdmin(usuario: usuario)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeCliente(usuario: usuario)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
