import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/pizza_base.dart';
import '../services/api_service.dart';
import '../screens/admin/pizza_form.dart';
import '../models/pizza_size.dart';

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
    if (isPizzaGroup) {
      // Usar pizzas predefinidas del menú
      _futureItems = Future.value(PizzaBase.defaultPizzas);
    } else {
      _futureItems = _apiService.getProductsByGroup(widget.groupId);
    }
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
                    _futureItems = Future.value(PizzaBase.defaultPizzas);
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          if (isPizzaGroup) {
            final pizzas = items as List<PizzaBase>;
            // Organizar pizzas por categoría
            final pizzasPorCategoria = <String, List<PizzaBase>>{};
            for (final pizza in pizzas) {
              pizzasPorCategoria
                  .putIfAbsent(pizza.category, () => [])
                  .add(pizza);
            }

            return ListView.builder(
              itemCount: pizzasPorCategoria.length,
              itemBuilder: (context, index) {
                final categoria = pizzasPorCategoria.keys.elementAt(index);
                final pizzasCategoria = pizzasPorCategoria[categoria]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        categoria.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    ...pizzasCategoria
                        .map(
                          (pizza) => ListTile(
                            leading: pizza.imageUrl != null
                                ? Image.network(pizza.imageUrl!, width: 50)
                                : const Icon(Icons.local_pizza),
                            title: Text(pizza.name),
                            subtitle: Text(pizza.description),
                            onTap: () => _mostrarDetallesPizza(pizza),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PizzaFormScreen(pizza: pizza),
                                    ),
                                  );
                                  if (updated == true) {
                                    setState(() {
                                      _futureItems = Future.value(
                                        PizzaBase.defaultPizzas,
                                      );
                                    });
                                  }
                                } else if (value == 'delete') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Eliminar pizza'),
                                      content: const Text(
                                        '¿Estás seguro de eliminar esta pizza?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    // Para pizzas predefinidas, solo refrescar la lista
                                    setState(() {
                                      _futureItems = Future.value(
                                        PizzaBase.defaultPizzas,
                                      );
                                    });
                                  }
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Editar'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Eliminar'),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                );
              },
            );
          } else {
            final products = items as List<Product>;
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
                  trailing: Text(' 24${product.price}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _mostrarDetallesPizza(PizzaBase pizza) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (pizza.imageUrl != null)
                  Image.network(
                    pizza.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                else
                  const Icon(Icons.local_pizza, size: 80),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pizza.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pizza.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Categoría: ${pizza.category.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Precios por tamaño:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...pizza.pricesBySize.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${entry.key} (${_getSizeInfo(entry.key)})'),
                    Text('\$${entry.value.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (pizza.includedIngredients.isNotEmpty) ...[
              const Text(
                'Ingredientes incluidos:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: pizza.includedIngredients
                    .map((ingredient) => Chip(label: Text(ingredient)))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Borde de queso (adicional):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...pizza.cheeseBorderPrices.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${entry.key}'),
                    Text('\$${entry.value.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSizeInfo(String size) {
    switch (size) {
      case 'PERSONAL':
        return '4 slices, 20cm';
      case 'SMALL':
        return '8 slices, 30cm';
      case 'MEDIUM':
        return '12 slices, 40cm';
      case 'LARGE':
        return '16 slices, 50cm';
      default:
        return '';
    }
  }
}
