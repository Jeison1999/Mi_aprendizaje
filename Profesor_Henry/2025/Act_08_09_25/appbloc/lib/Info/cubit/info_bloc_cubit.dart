import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'info_bloc_state.dart';

class InfoBlocCubit extends Cubit<InfoBlocState> {
  InfoBlocCubit() : super(InfoBlocInitial());

  Future<void> traerInfo() async {
    emit(InfoBlocLoading());
    await Future.delayed(Duration(seconds: 4));
    try {
      final response = await http.get(
        Uri.parse('https://mocki.io/v1/918c20ef-0f5f-4f2f-9622-15b76e767044'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = {
          'marca': 'Toyota Corolla',
          'placa': 'ABC123',
          'color': 'Rojo',
          'propietario': 'Jeison ortiz',
        };
        emit(InfoBlocSuccess(vehiculo: data));
      } else {
        emit(InfoBlocFailure());
      }
    } catch (e) {
      emit(InfoBlocFailure());
    }
  }
}
