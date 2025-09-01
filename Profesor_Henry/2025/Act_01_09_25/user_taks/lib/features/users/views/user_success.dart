import 'package:flutter/material.dart';

class UserSuccess extends StatelessWidget {
  const UserSuccess({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Hola, Carlos'),
          Text('Contacto: Usuario21@gmail.com'),
          Text('Saldo: 100.000'),
        ],
      ),
    );
  }
}