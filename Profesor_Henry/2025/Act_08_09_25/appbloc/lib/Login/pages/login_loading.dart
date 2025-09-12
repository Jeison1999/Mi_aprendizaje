import 'package:appbloc/imports/imports.dart';

class LoginLoading extends StatelessWidget {
  const LoginLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator()
      ],
    );
  }
}