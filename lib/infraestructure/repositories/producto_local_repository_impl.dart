
import 'package:mbarete_padel/domain/datasources/producto_local_datasource.dart';
import 'package:mbarete_padel/domain/entities/producto.dart';
import 'package:mbarete_padel/domain/entities/producto_local.dart';
import 'package:mbarete_padel/domain/repositories/producto_local_repository.dart';

class ProductoLocalRepositoryImpl extends ProductoLocalRepository{

  final ProductoLocalDatasource datasource;

  ProductoLocalRepositoryImpl(this.datasource);


  @override
  Future<List<ProductoLocal>?> listarProductos(int idLocal, int idReserva, String accessToken) async{
    return await datasource.listarProductos(idLocal, idReserva, accessToken);
  }

  @override
  Future<Producto?> crear(Map<String, dynamic> productoLike, String accessToken) async{
    return await datasource.crear(productoLike, accessToken);
  }

  @override
  Future<ProductoLocal?> crearProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
   return await datasource.crearProductoLocal(productoLocalLike, accessToken);
  }
  
  @override
  Future<ProductoLocal?> obtenerProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
    return await datasource.obtenerProductoLocal(productoLocalLike, accessToken);
  }
  
  @override
  Future<ProductoLocal?> eliminarProductoLocal(Map<String, dynamic> productoLocalLike, String accessToken) async{
    return await datasource.eliminarProductoLocal(productoLocalLike, accessToken);
  }
  
  @override
  Future<List<ProductoLocal>?> listarProductosAdmin(int idLocal, String accessToken) async{
    return await datasource.listarProductosAdmin(idLocal, accessToken);
  }

}