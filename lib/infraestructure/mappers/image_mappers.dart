import 'package:mbarete_padel/domain/entities/entities.dart';

class ImagenMapper {
  static jsonToEntity(Map<String, dynamic> json) => Imagen(
      idImagen: json['idImagen'], 
      nombre: json['nombre'], 
      tipo: json['tipo'], 
      imagenData: json['imagenData']
    );
}
