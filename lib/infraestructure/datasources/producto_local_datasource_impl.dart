
import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/producto_local_datasource.dart';
import 'package:mbarete_padel/domain/entities/producto.dart';
import 'package:mbarete_padel/domain/entities/producto_local.dart';
import 'package:mbarete_padel/infraestructure/mappers/producto_local_mappers.dart';
import 'package:mbarete_padel/infraestructure/mappers/producto_mappers.dart';

class ProductoLocalDatasourceImpl extends ProductoLocalDatasource{
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<List<ProductoLocal>?> listarProductos(int idLocal, int idReserva, String accessToken) async{
    try{
      final response = await dio.post('/productos-local/listar-reserva',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: {'idReserva':idReserva,'idLocal':idLocal}
      );
      final lista = List<ProductoLocal>.from(
        response.data.map((x) => ProductoLocalMapper.jsonToEntity(x)));
      return lista;
    }catch(e){
      return null;
    }
    
  }

  @override
  Future<Producto?> crear(Map<String, dynamic> productoLike, String accessToken) async{
    try{
      final response = await dio.post('/producto/crear',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: productoLike);
      final reserva =  ProductoMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }

  @override
  Future<ProductoLocal?> crearProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
    try{
      final response = await dio.post('/productos-local/crear',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: productoLocalLike);
      final reserva =  ProductoLocalMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<ProductoLocal?> obtenerProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
    try{
      final response = await dio.post('/productos-local/obtener',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: productoLocalLike);
      final reserva =  ProductoLocalMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<ProductoLocal?> eliminarProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
    try{
      final response = await dio.post('/productos-local/eliminar',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: productoLocalLike);
      final reserva =  ProductoLocalMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<List<ProductoLocal>?> listarProductosAdmin(int idLocal, String accessToken) async{
    try{
      final response = await dio.get('/productos-local/listar/$idLocal',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final lista = List<ProductoLocal>.from(
        response.data.map((x) => ProductoLocalMapper.jsonToEntity(x)));
      return lista;
    }catch(e){
      return null;
    }
  }

}