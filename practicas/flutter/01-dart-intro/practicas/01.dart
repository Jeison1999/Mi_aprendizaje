void main() {
  List<Libros> libros = [
    Libros(
      titulo: 'Cien años de soledad',
      autor: 'Gabriel García Márquez',
      anoPublicacion: 1967,
    ),
    Libros(
      titulo: 'Don Quijote de la Mancha',
      autor: 'Miguel de Cervantes',
      anoPublicacion: 1605,
    ),
    Libros(
      titulo: 'El Principito',
      autor: 'Antoine de Saint-Exupéry',
      anoPublicacion: 1943,
    ),
  ];

  for (var i in libros) {
    i.mostrarinformacion();
  }
}

class Libros {
  String titulo;
  String autor;
  int anoPublicacion;

  Libros({
    required this.titulo,
    required this.autor,
    required this.anoPublicacion,
  });

  mostrarinformacion() {
    print("""
    Titulo: $titulo,
    Autor: $autor,
    Año de publicaion: $anoPublicacion
    """);
  }
}
