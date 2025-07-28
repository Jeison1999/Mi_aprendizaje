class PizzaSize {
  final String name; // PERSONAL, SMALL, MEDIUM, LARGE
  final int slices;
  final int diameter; // en cm
  final int basePrice;

  const PizzaSize({
    required this.name,
    required this.slices,
    required this.diameter,
    required this.basePrice,
  });

  factory PizzaSize.fromJson(Map<String, dynamic> json) {
    return PizzaSize(
      name: json['name'],
      slices: json['slices'],
      diameter: json['diameter'],
      basePrice: json['base_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slices': slices,
      'diameter': diameter,
      'base_price': basePrice,
    };
  }

  static List<PizzaSize> get defaultSizes => [
    const PizzaSize(name: 'PERSONAL', slices: 4, diameter: 20, basePrice: 0),
    const PizzaSize(name: 'SMALL', slices: 8, diameter: 30, basePrice: 0),
    const PizzaSize(name: 'MEDIUM', slices: 12, diameter: 40, basePrice: 0),
    const PizzaSize(name: 'LARGE', slices: 16, diameter: 50, basePrice: 0),
  ];
} 