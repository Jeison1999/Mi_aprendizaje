import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();
}

class UserLoaded extends UserEvent {
  const UserLoaded();
}

class UserError extends UserEvent {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
