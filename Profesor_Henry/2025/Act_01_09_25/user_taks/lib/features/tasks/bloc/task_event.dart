import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class TasksLoaded extends TaskEvent {
  const TasksLoaded();
}

class TaskError extends TaskEvent {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
