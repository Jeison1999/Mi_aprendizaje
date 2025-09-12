part of 'info_bloc.dart';

sealed class InfoState extends Equatable {
  const InfoState();

  @override
  List<Object> get props => [];
}

final class InfoInitialState extends InfoState {}

final class InfoFailureState extends InfoState {}

final class InfoLoadingState extends InfoState {}

final class InfoSuccessState extends InfoState {
  final Map<String, dynamic> vehiculo;

  InfoSuccessState({required this.vehiculo});

  @override
  List<Object> get props => [vehiculo];
}
