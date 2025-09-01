import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<TasksLoaded>(_onTasksLoaded);
    on<TaskError>(_onTaskError);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    // Simular carga de tareas (aquí iría la llamada al backend)
    await Future.delayed(const Duration(seconds: 2));

    // Simular éxito o error aleatorio
    if (DateTime.now().millisecond % 3 == 0) {
      emit(const TaskSuccess());
    } else {
      emit(const TaskFailure('Error al cargar tareas'));
    }
  }

  void _onTasksLoaded(TasksLoaded event, Emitter<TaskState> emit) {
    emit(const TaskSuccess());
  }

  void _onTaskError(TaskError event, Emitter<TaskState> emit) {
    emit(TaskFailure(event.message));
  }
}
