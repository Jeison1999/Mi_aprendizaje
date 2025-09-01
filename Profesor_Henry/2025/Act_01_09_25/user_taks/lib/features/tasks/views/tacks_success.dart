import 'package:flutter/material.dart';

class TasksSuccess extends StatelessWidget {
  const TasksSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskCard(
            'Completar proyecto Flutter',
            'Finalizar la implementación de la aplicación de tareas y usuarios con todas las funcionalidades requeridas.',
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildTaskCard(
            'Revisar documentación',
            'Leer y actualizar la documentación del proyecto para mantener un registro actualizado de las funcionalidades.',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String description, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
