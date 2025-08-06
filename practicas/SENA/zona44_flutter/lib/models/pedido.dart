// Modelo de Pedido
class Pedido {
  final String id;
  final String usuarioId;
  final List<String> productos;

  Pedido({required this.id, required this.usuarioId, required this.productos});
}
