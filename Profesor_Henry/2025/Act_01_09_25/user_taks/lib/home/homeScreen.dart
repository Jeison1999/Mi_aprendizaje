import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/tasks/views/tacks_success.dart';
import '../features/tasks/views/tasks_loading.dart';
import '../features/tasks/views/task_failure.dart' as task_view;
import '../features/tasks/views/tacks_initial.dart';
import '../features/users/views/user_success.dart' as user_success_view;
import '../features/users/views/user_loading.dart' as user_loading_view;
import '../features/users/views/user_failure.dart' as user_view;
import '../features/tasks/bloc/task_bloc.dart';
import '../features/tasks/bloc/task_event.dart';
import '../features/tasks/bloc/task_state.dart';
import '../features/users/bloc/user_bloc.dart';
import '../features/users/bloc/user_event.dart';
import '../features/users/bloc/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
      ],
      child: Scaffold(
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
            // User Section
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial) {
                  return user_view.UserFailure(
                    onRetry: () {
                      context.read<UserBloc>().add(const LoadUser());
                    },
                  );
                } else if (state is UserLoading) {
                  return const user_loading_view.UserLoading();
                } else if (state is UserSuccess) {
                  return const user_success_view.UserSuccess();
                } else if (state is UserFailure) {
                  return user_view.UserFailure(
                    onRetry: () {
                      context.read<UserBloc>().add(const LoadUser());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Tasks Section
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

            BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskInitial) {
                  return TasksInitial(
                    onLoadTasks: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                  );
                } else if (state is TaskLoading) {
                  return const TasksLoading();
                } else if (state is TaskSuccess) {
                  return const TasksSuccess();
                } else if (state is TaskFailure) {
                  return task_view.TaskFailure(
                    onRetry: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
