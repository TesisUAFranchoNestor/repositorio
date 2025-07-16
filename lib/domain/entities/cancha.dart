import 'entities.dart';

class Cancha {
  
  final int idCancha;
  final Local local;
  final double precio;
  final String descripcion;
  final int idImagen;
  final int estado;

  Cancha({
    required this.idCancha, 
    required this.local, 
    required this.precio, 
    required this.descripcion, 
    required this.idImagen, 
    required this.estado
  });
  

}
