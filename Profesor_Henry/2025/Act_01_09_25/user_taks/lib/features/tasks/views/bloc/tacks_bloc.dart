import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tacks_event.dart';
part 'tacks_state.dart';

class TacksBloc extends Bloc<TacksEvent, TacksState> {
  TacksBloc() : super(TacksInitial()) {
    on<TacksEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
