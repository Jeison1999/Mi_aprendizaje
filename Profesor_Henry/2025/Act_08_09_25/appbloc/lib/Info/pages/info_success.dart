import 'package:appbloc/imports/imports.dart';

class InfoSuccess extends StatelessWidget {
  final Size size;
  final Map<String, dynamic> vehiculo;

  const InfoSuccess({super.key, required this.size, required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      height: size.height * 0.5,
      width: size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Marca: ${vehiculo['marca']}'),
          Text('Placa: ${vehiculo['placa']}'),
          Text('Color: ${vehiculo['color']}'),
          Text('Propietario: ${vehiculo['propietario']}'),
        ],
      ),
    );
  }
}
