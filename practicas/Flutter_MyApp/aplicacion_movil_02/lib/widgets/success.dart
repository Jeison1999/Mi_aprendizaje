// Success
import 'package:flutter/material.dart';
import 'package:aplicacion_movil_02/models/post.dart';

class Success extends StatelessWidget {
  final User user;

  const Success({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Id: ${user.id.toString()}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Name: ${user.name!}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Text(
              'User: ${user.username!}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Email: ${user.email!}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text('Phone: ${user.phone!}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center),
            const SizedBox(height: 10.0),
            Text('Website: ${user.website!}',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center),
            const SizedBox(height: 10.0),
            Text(user.address.toString(),
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center),
            Text(user.address!.geo.toString(),
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center),
            Text(user.company.toString(),
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
