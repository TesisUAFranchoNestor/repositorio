
import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/reserva_producto_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva_producto.dart';
import 'package:mbarete_padel/infraestructure/mappers/reserva_producto_mappers.dart';

class ReservaProductoDatasourceImpl extends ReservaProductoDatasource{

  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<List<ReservaProducto>?> listarProductos(int idReserva, String accessToken) async {
    try{
      final response = await dio.post('/reserva-productos/listar',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: {'idReserva':idReserva});

      final lista = List<ReservaProducto>.from(
        response.data.map((x) => ReservaProductoMappers.jsonToEntity(x)));
      return lista;
      
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<ReservaProducto?> crear(Map<String, dynamic> reservaProductoLike, String accessToken) async {
    try{
      final response = await dio.post('/reserva-productos/crear',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: reservaProductoLike);
      final reserva =  ReservaProductoMappers.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<bool> eliminar(int idReserva, int idProducto, String accessToken) async {
    try{
      final response = await dio.delete('/reserva-productos/eliminar',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: {'idReserva':idReserva, 'idProducto':idProducto});
      return response.statusCode == 200 ? true : false; 
    }catch(e){
      return false;
    }
  }

}