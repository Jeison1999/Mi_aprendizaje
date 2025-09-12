part of 'info_bloc.dart';

sealed class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object> get props => [];
}

class TraerinfoEvent extends InfoEvent {}