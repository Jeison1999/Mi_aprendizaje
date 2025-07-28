import 'pizza_size.dart';
import 'ingredient.dart';

class PizzaBase {
  final int? id;
  final String name;
  final String description;
  final String category; // tradicional, especial, combinada
  final String? imageUrl;
  final Map<String, int> pricesBySize; // Precios por tamaño
  final List<String> includedIngredients; // Ingredientes incluidos
  final Map<String, int>
  cheeseBorderPrices; // Precios del borde de queso por tamaño
  final bool isCombinada; // Si es pizza combinada (armada al gusto)

  PizzaBase({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.pricesBySize,
    required this.includedIngredients,
    required this.cheeseBorderPrices,
    this.isCombinada = false,
  });

  factory PizzaBase.fromJson(Map<String, dynamic> json) {
    final pricesMap = <String, int>{};
    if (json['prices_by_size'] != null) {
      final prices = json['prices_by_size'] as Map<String, dynamic>;
      prices.forEach((key, value) {
        pricesMap[key] = value as int;
      });
    }

    final ingredientsList = <String>[];
    if (json['included_ingredients'] != null) {
      ingredientsList.addAll(
        (json['included_ingredients'] as List).cast<String>(),
      );
    }

    final cheeseBorderMap = <String, int>{};
    if (json['cheese_border_prices'] != null) {
      final prices = json['cheese_border_prices'] as Map<String, dynamic>;
      prices.forEach((key, value) {
        cheeseBorderMap[key] = value as int;
      });
    }

    return PizzaBase(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'tradicional',
      imageUrl: json['image_url'],
      pricesBySize: pricesMap,
      includedIngredients: ingredientsList,
      cheeseBorderPrices: cheeseBorderMap,
      isCombinada: json['is_combinada'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'prices_by_size': pricesBySize,
      'included_ingredients': includedIngredients,
      'cheese_border_prices': cheeseBorderPrices,
      'is_combinada': isCombinada,
    };
  }

  int getPriceForSize(String size) {
    return pricesBySize[size] ?? 0;
  }

  int getCheeseBorderPriceForSize(String size) {
    return cheeseBorderPrices[size] ?? 0;
  }

  // Métodos de compatibilidad con el código existente
  bool? get hasCheeseBorder => cheeseBorderPrices.isNotEmpty;
  int? get cheeseBorderPrice =>
      cheeseBorderPrices.isNotEmpty ? cheeseBorderPrices.values.first : null;
  List<Map<String, dynamic>>? get sizes {
    return pricesBySize.entries
        .map((entry) => {'size': entry.key, 'price': entry.value})
        .toList();
  }

  // Pizzas predefinidas según el menú
  static List<PizzaBase> get defaultPizzas => [
    // PIZZAS TRADICIONALES
    PizzaBase(
      name: 'JAMÓN Y QUESO',
      description: 'Deliciosa pizza con jamón y queso',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 17000,
        'SMALL': 28000,
        'MEDIUM': 38000,
        'LARGE': 48000,
      },
      includedIngredients: ['JAMÓN', 'QUESO'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'HAWAIANA',
      description: 'Pizza con jamón y piña',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 20000,
        'SMALL': 32000,
        'MEDIUM': 42000,
        'LARGE': 54000,
      },
      includedIngredients: ['JAMÓN', 'PIÑA'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'POLLO',
      description: 'Pizza con pollo',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 21000,
        'SMALL': 34000,
        'MEDIUM': 45000,
        'LARGE': 58000,
      },
      includedIngredients: ['POLLO'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'SUIZA',
      description: 'Pizza suiza',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 21000,
        'SMALL': 34000,
        'MEDIUM': 45000,
        'LARGE': 58000,
      },
      includedIngredients: ['QUESO SUIZO'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'PEPERONI',
      description: 'Pizza con peperoni',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 21000,
        'SMALL': 34000,
        'MEDIUM': 45000,
        'LARGE': 58000,
      },
      includedIngredients: ['PEPERONI'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'TOCINETA',
      description: 'Pizza con tocineta',
      category: 'tradicional',
      pricesBySize: {
        'PERSONAL': 21000,
        'SMALL': 34000,
        'MEDIUM': 45000,
        'LARGE': 58000,
      },
      includedIngredients: ['TOCINETA'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),

    // PIZZAS ESPECIALES
    PizzaBase(
      name: 'COSTEÑA',
      description: 'CHORIZO, BUTIFARRA, MAIZ, PIMENTON Y CEBOLLA',
      category: 'especial',
      pricesBySize: {
        'PERSONAL': 22000,
        'SMALL': 36000,
        'MEDIUM': 48000,
        'LARGE': 67000,
      },
      includedIngredients: [
        'CHORIZO',
        'BUTIFARRA',
        'MAÍZ',
        'PIMENTÓN',
        'CEBOLLA',
      ],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'CUATRO CARNES',
      description: 'POLLO, SUIZA, TOCINETAS, PEPERONI',
      category: 'especial',
      pricesBySize: {
        'PERSONAL': 28000,
        'SMALL': 45000,
        'MEDIUM': 58000,
        'LARGE': 71000,
      },
      includedIngredients: ['POLLO', 'SUIZA', 'TOCINETA', 'PEPERONI'],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),
    PizzaBase(
      name: 'ZONA 44',
      description: 'POLLO, SUIZA, TOCINETA, CHAMPIÑÓN PIMENTÓN, CEBOLLA Y MAÍZ',
      category: 'especial',
      pricesBySize: {
        'PERSONAL': 30000,
        'SMALL': 48000,
        'MEDIUM': 62000,
        'LARGE': 77000,
      },
      includedIngredients: [
        'POLLO',
        'SUIZA',
        'TOCINETA',
        'CHAMPIÑÓN',
        'PIMENTÓN',
        'CEBOLLA',
        'MAÍZ',
      ],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
    ),

    // PIZZAS COMBINADAS
    PizzaBase(
      name: 'COMBINADA',
      description:
          'Armada al gusto escogiendo dos ingredientes de tu pizza tradicional',
      category: 'combinada',
      pricesBySize: {
        'PERSONAL': 24000,
        'SMALL': 38000,
        'MEDIUM': 52000,
        'LARGE': 70000,
      },
      includedIngredients: [],
      cheeseBorderPrices: {
        'PERSONAL': 10000,
        'SMALL': 15000,
        'MEDIUM': 20000,
        'LARGE': 24000,
      },
      isCombinada: true,
    ),
  ];
}
