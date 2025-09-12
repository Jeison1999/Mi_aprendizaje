import 'package:appbloc/Login/bloc/login_bloc.dart';
import 'package:appbloc/imports/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: Center(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessbloc) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Info(
                    cedula: state.cedula,
                    nombre: state.nombre,
                  )),
                  
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInitialbloc) {
                  return LoginInitial();
                } else if (state is LoginLoadingbloc) {
                  return LoginLoading();
                } else if (state is LoginFailurebloc) {
                  return LoginFailure();
                }
                return LoginInitial();
              },
            ),
          ),
        ),
      ),
    );
  }
}
