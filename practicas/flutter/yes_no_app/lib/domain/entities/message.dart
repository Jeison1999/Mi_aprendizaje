enum FromWho { me, hers }

class Message {
  final String text;
  final String? imagenUrl;
  final FromWho fromWho;

  Message({required this.text, this.imagenUrl, required this.fromWho});
}
