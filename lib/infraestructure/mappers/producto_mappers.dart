import 'package:mbarete_padel/domain/entities/entities.dart';

class ProductoMapper {
  static jsonToEntity(Map<String, dynamic> json) => Producto(
    idProducto: json['idProducto'], 
    titulo: json['titulo'], 
    marca: json['marca'], 
    descripcion: json['descripcion'],
    idImagen: json['idImagen'] 
  );
}
