
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class ReservaProductoRepository{

  Future<List<ReservaProducto>?> listarProductos( int idReserva, String accessToken );
  Future<ReservaProducto?> crear( Map<String,dynamic> reservaProductoLike, String accessToken );
  Future<bool> eliminar( int idReserva, int idProducto, String accessToken );

}