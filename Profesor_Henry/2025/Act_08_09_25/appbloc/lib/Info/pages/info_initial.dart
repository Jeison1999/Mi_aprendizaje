import 'package:appbloc/imports/imports.dart';

class InfoInitial extends StatelessWidget {
  const InfoInitial({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      height: size.height * 0.5,
      width: size.width * 0.8,
    );
  }
}
