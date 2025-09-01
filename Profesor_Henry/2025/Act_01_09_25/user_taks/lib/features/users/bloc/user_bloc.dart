import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UserLoaded>(_onUserLoaded);

    on<UserError>(_onUserError);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    // Simular carga de usuario (aquí iría la llamada al backend)
    await Future.delayed(const Duration(seconds: 2));

    // Simular éxito o error aleatorio
    if (DateTime.now().millisecond % 2 == 0) {
      emit(const UserSuccess());
    } else {
      emit(const UserFailure('Error al cargar usuario'));
    }
  }

  void _onUserLoaded(UserLoaded event, Emitter<UserState> emit) {
    emit(const UserSuccess());
  }

  void _onUserError(UserError event, Emitter<UserState> emit) {
    emit(UserFailure(event.message));
  }
}
