class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String? imageUrl;
  final int grupoId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.grupoId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '') ?? 0,
      imageUrl: json['image_url'],
      grupoId: json['grupo_id'] is int
          ? json['grupo_id']
          : int.tryParse(json['grupo_id']?.toString() ?? '') ?? 0,
    );
  }
}
