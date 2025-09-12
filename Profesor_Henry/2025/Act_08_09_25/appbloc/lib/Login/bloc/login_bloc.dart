import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialbloc()) {
    on<CrearUsuarioEvent>((event, emit) async {
      emit(LoginLoadingbloc()); // Emitir estado de carga

      await Future.delayed(Duration(seconds: 1)); // Simular espera

      int? cedulaInt = int.tryParse(event.cedula);
      bool cedulaValida =
          cedulaInt != null && event.cedula.length >= 5 && cedulaInt > 0;
      bool nombreValido = event.nombre.isNotEmpty;
      if (cedulaValida && nombreValido) {
        emit(LoginSuccessbloc(cedula: cedulaInt, nombre: event.nombre));
      } else {
        emit(LoginFailurebloc());
      }
    });
  }
}
