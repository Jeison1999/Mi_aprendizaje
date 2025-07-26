import 'package:flutter/material.dart';
import '../models/product.dart';
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
  late Future<List<Product>> _futureProducts;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _futureProducts = _apiService.getProductsByGroup(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.groupName)),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!, width: 50)
                    : const Icon(Icons.fastfood),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('\$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
