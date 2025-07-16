import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/producto_mappers.dart';

class ProductoLocalMapper {
  static jsonToEntity(Map<String, dynamic> json) => ProductoLocal(
    idProducto: json['idProducto'] ?? -1, 
    idLocal: json['idLocal'] ?? -1, 
      producto: json['producto'] != null 
          ? ProductoMapper.jsonToEntity(json['producto']) 
          : Producto(idProducto: 0, titulo: '', marca: '', descripcion: ''), 
    stock: json['stock'] ?? 0, 
    precio: json['precio'] ?? 0);
}
