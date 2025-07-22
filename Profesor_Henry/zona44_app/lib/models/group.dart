class Group {
  final int id;
  final String name;
  final String? imageUrl;


  Group({required this.id, required this.name, this.imageUrl});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
