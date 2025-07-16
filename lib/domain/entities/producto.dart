
class Producto {
  


  final int idProducto;
  final String titulo;
  final String marca;
  final String descripcion;
  final int? idImagen;

  Producto({
    required this.idProducto, 
    required this.titulo, 
    required this.marca, 
    required this.descripcion,
    this.idImagen
  });

 
  

}
