import 'package:flutter/material.dart';
import 'package:zona44_app/models/pizza_base.dart';
import 'package:zona44_app/services/api_service.dart';
import 'package:zona44_app/screens/admin/pizza_form.dart'; // Asegúrate de que este import exista

class PizzaAdminScreen extends StatefulWidget {
  const PizzaAdminScreen({super.key});

  @override
  State<PizzaAdminScreen> createState() => _PizzaAdminScreenState();
}

class _PizzaAdminScreenState extends State<PizzaAdminScreen> {
  List<PizzaBase> _pizzas = [];
  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPizzas();
  }

  Future<void> _loadPizzas() async {
    final pizzas = await _api.fetchPizzaBases(); // Asegúrate que esté implementado en ApiService
    setState(() => _pizzas = pizzas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administrar Pizzas')),
      body: _pizzas.isEmpty
          ? Center(child: Text('No hay pizzas registradas'))
          : ListView.builder(
              itemCount: _pizzas.length,
              itemBuilder: (_, i) {
                final pizza = _pizzas[i];
                return ListTile(
                  leading: pizza.imageUrl != null
                      ? Image.network(pizza.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.local_pizza),
                  title: Text(pizza.name),
                  subtitle: Text(pizza.category.toUpperCase()),
                  trailing: Icon(Icons.edit),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PizzaFormScreen(pizza: pizza),
                      ),
                    );
                    if (updated == true) _loadPizzas();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PizzaFormScreen(),
            ),
          );
          if (created == true) _loadPizzas();
        },
        child: Icon(Icons.add),
        tooltip: 'Crear nueva pizza',
      ),
    );
  }
}
