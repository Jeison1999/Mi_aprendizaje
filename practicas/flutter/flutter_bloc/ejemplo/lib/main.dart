import 'package:ejemplo/features/home/presentation/bloc/home_bloc.dart';
import 'package:ejemplo/features/home/presentation/views/failure_views.dart';
import 'package:ejemplo/features/home/presentation/views/initial_views.dart';
import 'package:ejemplo/features/home/presentation/views/loading_views.dart';
import 'package:ejemplo/features/home/presentation/views/success_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(Sena());
}

class Sena extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: MaterialApp(
        home: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadloading) {
              return Loading();
            } else if (state is HomeLoadSuccess) {
              return Success();
            } else if (state is HomeLoadFailure) {
              return Failure();
            }
            return initial();
          },
        ),
      ),
    );
  }
}
