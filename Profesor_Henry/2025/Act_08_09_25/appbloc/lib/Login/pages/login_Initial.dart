import 'package:appbloc/Login/bloc/login_bloc.dart';
import 'package:appbloc/imports/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginInitial extends StatelessWidget {
  const LoginInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final cedulaController = TextEditingController();
    final nombreController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Cedula:'),
        SizedBox(height: 8),
        TextField(
          controller: cedulaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide()),
            hintText: 'Ingrese su cedula',
          ),
        ),
        Text('Nombre:'),
        SizedBox(height: 8),
        TextField(
          controller: nombreController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide()),
            hintText: 'Ingrese su nombre',
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<LoginBloc>(context).add(
              CrearUsuarioEvent(
                cedula: cedulaController.text,
                nombre: nombreController.text,
              ),
            );
          },
          child: Text('Crear Usuario'),
        ),
      ],
    );
  }
}
