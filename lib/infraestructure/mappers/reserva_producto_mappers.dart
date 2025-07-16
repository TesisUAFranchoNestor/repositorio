import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/producto_mappers.dart';

class ReservaProductoMappers {
  static jsonToEntity(Map<String, dynamic> json) => ReservaProducto(
    idReserva: json['idReserva'], 
    idProducto: json['idProducto'], 
    cantidad: json['cantidad'], 
    precioUnitario: json['precioUnitario'], 
    producto: json['producto']==null ? null : ProductoMapper.jsonToEntity(json['producto'])
  );
}