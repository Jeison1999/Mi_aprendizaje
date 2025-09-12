part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitialbloc extends LoginState {}

final class LoginFailurebloc extends LoginState {}

final class LoginLoadingbloc extends LoginState {}

final class LoginSuccessbloc extends LoginState {
  final int cedula;
  final String nombre;

  LoginSuccessbloc({required this.cedula, required this.nombre});

}
