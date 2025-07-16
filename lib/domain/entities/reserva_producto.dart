import 'entities.dart';

class ReservaProducto {

  final int idReserva;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final Producto? producto;

  ReservaProducto({
    required this.idReserva, 
    required this.idProducto, 
    required this.cantidad, 
    required this.precioUnitario, 
    required this.producto
  });

 ReservaProducto copyWith({
    int? idReserva,
    int? idProducto,
    int? cantidad,
    double? precioUnitario,
    Producto? producto,
  }) => ReservaProducto(
    idReserva: idReserva ?? this.idReserva,
    idProducto: idProducto ?? this.idProducto,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    producto: producto ?? this.producto,
  );
  

}
