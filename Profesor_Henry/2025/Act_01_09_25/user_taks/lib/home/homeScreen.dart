import 'package:flutter/material.dart';
import '../features/tasks/views/tacks_initial.dart';
import '../features/tasks/views/tasks_failure.dart';
import '../features/users/views/user_failure.dart';
import '../features/users/views/user_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          UserFailure(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Tareas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          TasksInitial(),
        ],
      ),
    );
  }
}
