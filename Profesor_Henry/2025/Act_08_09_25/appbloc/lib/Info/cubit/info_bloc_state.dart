part of 'info_bloc_cubit.dart';

sealed class InfoBlocState extends Equatable {
  const InfoBlocState();

  @override
  List<Object> get props => [];
}

final class InfoBlocInitial extends InfoBlocState {}

final class InfoBlocLoading extends InfoBlocState {}

final class InfoBlocFailure extends InfoBlocState {}

final class InfoBlocSuccess extends InfoBlocState {
  final Map<String, dynamic> vehiculo;
  const InfoBlocSuccess({required this.vehiculo});
  @override
  List<Object> get props => [vehiculo];
}