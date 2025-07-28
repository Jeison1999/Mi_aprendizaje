class Ingredient {
  final int? id;
  final String name;
  final Map<String, int>
  pricesBySize; // Precio por tamaño: PERSONAL, SMALL, MEDIUM, LARGE
  final String? imageUrl;
  final bool isAvailable;

  const Ingredient({
    this.id,
    required this.name,
    required this.pricesBySize,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    final pricesMap = <String, int>{};
    if (json['prices_by_size'] != null) {
      final prices = json['prices_by_size'] as Map<String, dynamic>;
      prices.forEach((key, value) {
        pricesMap[key] = value as int;
      });
    }

    return Ingredient(
      id: json['id'],
      name: json['name'],
      pricesBySize: pricesMap,
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prices_by_size': pricesBySize,
      'image_url': imageUrl,
      'is_available': isAvailable,
    };
  }

  int getPriceForSize(String size) {
    return pricesBySize[size] ?? 0;
  }

  static List<Ingredient> get defaultIngredients => [
    const Ingredient(
      name: 'PIÑA',
      pricesBySize: {
        'PERSONAL': 5000,
        'SMALL': 7000,
        'MEDIUM': 8000,
        'LARGE': 10000,
      },
    ),
    const Ingredient(
      name: 'MAÍZ',
      pricesBySize: {
        'PERSONAL': 5000,
        'SMALL': 7000,
        'MEDIUM': 8000,
        'LARGE': 10000,
      },
    ),
    const Ingredient(
      name: 'CHAMPIÑÓN',
      pricesBySize: {
        'PERSONAL': 5000,
        'SMALL': 8000,
        'MEDIUM': 10000,
        'LARGE': 14000,
      },
    ),
    const Ingredient(
      name: 'TOCINETA',
      pricesBySize: {
        'PERSONAL': 5000,
        'SMALL': 8000,
        'MEDIUM': 10000,
        'LARGE': 14000,
      },
    ),
  ];
}
