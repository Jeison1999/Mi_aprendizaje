class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String? imageUrl;
  final int groupId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.groupId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image_url'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = 'http://localhost:3000$imageUrl';
    }
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Product(
      id: parseInt(json['id']),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parseInt(json['price']),
      imageUrl: imageUrl,
      groupId: parseInt(json['group_id']),
    );
  }
}
