import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(InfoInitialState()) {
    on<TraerinfoEvent>((event, emit) async {
      emit(InfoLoadingState());
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
          emit(InfoSuccessState(vehiculo: data));
        } else {
          emit(InfoFailureState());
        }
      } catch (e) {
        emit(InfoFailureState());
      }
    });
  }
}
