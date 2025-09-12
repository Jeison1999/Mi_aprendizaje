import 'package:appbloc/imports/imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/info_bloc.dart';

class Info extends StatelessWidget {
  final int cedula;
  final String nombre;
  const Info({required this.cedula, required this.nombre, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Bienvenido'))),
      body: BlocProvider(
        create: (context) => InfoBloc()..add(TraerinfoEvent()),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/descarga.jpeg',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: size.height * 0.1),
            BlocBuilder<InfoBloc, InfoState>(
              builder: (context, state) {
                if (state is InfoInitialState) {
                  return InfoInitial(size: size);
                } else if (state is InfoLoadingState) {
                  return InfoLoading(size: size);
                } else if (state is InfoFailureState) {
                  return InfoFailure(size: size);
                  
                } else if (state is InfoSuccessState) {
                  return InfoSuccess(size: size, vehiculo: state.vehiculo);
                }
                return Center(child: Text('Cargando datos'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
