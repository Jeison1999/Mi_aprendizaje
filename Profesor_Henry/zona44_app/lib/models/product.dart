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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'],
      grupoId: json['grupo_id'],
    );
  }
}
