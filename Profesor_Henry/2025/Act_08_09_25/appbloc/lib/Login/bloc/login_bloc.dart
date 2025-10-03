import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialbloc()) {
    on<CrearUsuarioEvent>((event, emit) async {
      emit(LoginLoadingbloc());

      try {
        // Validaciones básicas
        int? cedulaInt = int.tryParse(event.cedula);
        bool cedulaValida =
            cedulaInt != null && event.cedula.length >= 5 && cedulaInt > 0;
        bool nombreValido = event.nombre.isNotEmpty;

        if (!cedulaValida || !nombreValido) {
          emit(LoginFailurebloc());
          return;
        }

        // Hacer petición a mocki.io
        final response = await http.get(
          Uri.parse('https://mocki.io/v1/b6105eb2-46aa-4eac-bba6-6132944e1758'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> usuarios = data['usuarios'];

          // Buscar usuario por cédula y nombre
          final usuarioEncontrado = usuarios.firstWhere(
            (usuario) =>
                usuario['cedula'] == event.cedula &&
                usuario['nombre'] == event.nombre &&
                usuario['activo'] == true,
            orElse: () => null,
          );

          if (usuarioEncontrado != null) {
            emit(LoginSuccessbloc(cedula: cedulaInt, nombre: event.nombre));
          } else {
            emit(LoginFailurebloc());
          }
        } else {
          emit(LoginFailurebloc());
        }
      } catch (e) {
        emit(LoginFailurebloc());
      }
    });
  }
}
