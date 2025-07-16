
import 'package:mbarete_padel/domain/datasources/reserva_producto_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva_producto.dart';
import 'package:mbarete_padel/domain/repositories/reserva_producto_repository.dart';

class ReservaProductoRepositoryImpl extends ReservaProductoRepository{

  final ReservaProductoDatasource datasource;

  ReservaProductoRepositoryImpl({required this.datasource});


  @override
  Future<List<ReservaProducto>?> listarProductos(int idReserva, String accessToken) async{
    return await datasource.listarProductos( idReserva, accessToken );
  }
  
  @override
  Future<ReservaProducto?> crear(Map<String, dynamic> reservaProductoLike, String accessToken) async {
    return await datasource.crear(reservaProductoLike, accessToken);
  }
  
  @override
  Future<bool> eliminar(int idReserva, int idProducto, String accessToken) async {
    return await datasource.eliminar( idReserva, idProducto, accessToken );
  }
}