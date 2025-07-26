class PizzaBase {
  final int? id;
  final String name;
  final String description;
  final String category; // tradicional, especial, combinada
  final String? imageUrl;

  PizzaBase({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
  });

  factory PizzaBase.fromJson(Map<String, dynamic> json) {
    return PizzaBase(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'tradicional',
      imageUrl: json['image_url'],
    );
  }

  get sizes => null;

  get hasCheeseBorder => null;

  get cheeseBorderPrice => null;

  Map<String, String> toJson() {
    return {'name': name, 'description': description, 'category': category};
  }
}
