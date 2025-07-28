import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pizza_base.dart';
import '../services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  const ProductsScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<dynamic>> _futureItems;
  final _apiService = ApiService();
  late bool isPizzaGroup;

  @override
  void initState() {
    super.initState();
    isPizzaGroup = widget.groupName.toLowerCase().contains('pizza');
    _futureItems = isPizzaGroup
        ? _apiService.fetchPizzaBasesByGroup(widget.groupId)
        : _apiService.getProductsByGroup(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    isPizzaGroup = widget.groupName.toLowerCase().contains('pizza');
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      floatingActionButton: isPizzaGroup
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/pizza_form',
                );
                if (result == true) {
                  setState(() {
                    _futureItems = _apiService.fetchPizzaBasesByGroup(
                      widget.groupId,
                    );
                  });
                }
              },
            )
          : null,
      body: FutureBuilder<List<dynamic>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error:  [200msnapshot.error'));
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              if (isPizzaGroup) {
                final pizza = items[index] as PizzaBase;
                return ListTile(
                  leading: pizza.imageUrl != null
                      ? Image.network(pizza.imageUrl!, width: 50)
                      : const Icon(Icons.local_pizza),
                  title: Text(pizza.name),
                  subtitle: Text(pizza.description),
                  trailing: Text(pizza.category),
                );
              } else {
                final product = items[index] as Product;
                return ListTile(
                  leading: product.imageUrl != null
                      ? Image.network(product.imageUrl!, width: 50)
                      : const Icon(Icons.fastfood),
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text(' 24${product.price}'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
