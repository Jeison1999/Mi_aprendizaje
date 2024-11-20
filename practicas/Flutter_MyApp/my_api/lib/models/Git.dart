class Gif {
  final String title;
  final String url;

  Gif({required this.title, required this.url});

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      title: json['title'], // Ajusta esto según la estructura de tu JSON
      url: json['images']['fixed_height']
          ['url'], // Ajusta esto según la estructura de tu JSON
    );
  }
}
