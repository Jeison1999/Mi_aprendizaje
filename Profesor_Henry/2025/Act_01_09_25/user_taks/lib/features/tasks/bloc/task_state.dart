import 'package:equatable/equatable.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskSuccess extends TaskState {
  const TaskSuccess();
}

class TaskFailure extends TaskState {
  final String message;

  const TaskFailure(this.message);

  @override
  List<Object?> get props => [message];
}
