part of 'tacks_bloc.dart';

sealed class TacksState extends Equatable {
  const TacksState();
  
  @override
  List<Object> get props => [];
}

final class TacksInitial extends TacksState {}
