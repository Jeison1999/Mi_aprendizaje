import 'package:appbloc/imports/imports.dart';

class LoginFailure extends StatelessWidget {
  const LoginFailure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon( Icons.cancel_outlined),
          Text('Datos incorrectos, intenta de nuevo'),
        ]
    );
  }
}