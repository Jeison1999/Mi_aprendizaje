class Group {
  final int id;
  final String name;
  final String? imageUrl; // <- hacerlo opcional

  Group({required this.id, required this.name, this.imageUrl});

  factory Group.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image_url'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = 'http://localhost:3000$imageUrl'; // Cambia por tu dominio real en producción
    }
    return Group(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: imageUrl,
    );
  }
}
