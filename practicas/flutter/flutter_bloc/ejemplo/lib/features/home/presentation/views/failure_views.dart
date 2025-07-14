import 'package:flutter/material.dart';

class Failure extends StatelessWidget {
  const Failure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [Text('ERROR 404')]),
      ),
    );
  }
}