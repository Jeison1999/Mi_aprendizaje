import 'package:ejemplo/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class initial extends StatelessWidget {
  const initial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Bienvenido'),
            Text('Señor Jeison'),
            ElevatedButton(onPressed: () {
              context.read<HomeBloc>().add(HomeEnterPressend());
            }, child: Text('Presionar')),
          ],
        ),
      ),
    );
  }
}
