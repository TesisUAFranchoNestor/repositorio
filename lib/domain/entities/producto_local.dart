import 'entities.dart';

class ProductoLocal {
  
  final int idProducto;
  final int idLocal;
  final Producto producto;
  final int stock;
  final double precio;
  int? cantidad;

  ProductoLocal({
    required this.idProducto, 
    required this.idLocal, 
    required this.producto, 
    required this.stock, 
    required this.precio,
    this.cantidad = 0
});

  ProductoLocal copyWith({
    int? idProducto,
    int? idLocal,
    double? precio,
    int? stock,
    Producto? producto,
    int? cantidad
  }) => ProductoLocal(
    idProducto: idProducto ?? this.idProducto,
    idLocal: idLocal ?? this.idLocal,
    precio: precio ?? this.precio,
    stock: stock ?? this.stock,
    producto: producto ?? this.producto,
    cantidad: cantidad ?? this.cantidad,
  );
  

}
