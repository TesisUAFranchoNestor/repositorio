
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class ProductoLocalRepository{

  Future<List<ProductoLocal>?> listarProductos( int idLocal, int idReserva, String accessToken );
  Future<List<ProductoLocal>?> listarProductosAdmin( int idLocal, String accessToken );

  Future<Producto?> crear( Map<String,dynamic> productoLike, String accessToken );

  Future<ProductoLocal?> crearProductoLocal( Map<String,dynamic> productoLocalLike, String accessToken );

  Future<ProductoLocal?> obtenerProductoLocal( Map<String,dynamic> productoLocalLike, String accessToken );

  Future<ProductoLocal?> eliminarProductoLocal( Map<String,dynamic> productoLocalLike, String accessToken );

}