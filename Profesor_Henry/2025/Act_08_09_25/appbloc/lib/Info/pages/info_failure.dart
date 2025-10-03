import 'package:appbloc/imports/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appbloc/Info/cubit/info_bloc_cubit.dart';

class InfoFailure extends StatelessWidget {
  const InfoFailure({super.key, required this.size});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cancel_outlined),
          Text('Error al cargar los datos'),
          ElevatedButton(
            onPressed: () {
              context.read<InfoBlocCubit>().traerInfo();
            },
            child: Text('reintentar'),
          ),
        ],
      ),
    );
  }
}
