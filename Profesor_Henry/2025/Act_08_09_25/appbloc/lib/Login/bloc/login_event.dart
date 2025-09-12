part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class CrearUsuarioEvent extends LoginEvent {
  final String cedula;
  final String nombre;

   CrearUsuarioEvent({required this.cedula, required this.nombre});

}
