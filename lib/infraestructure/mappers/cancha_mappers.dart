import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/local_mappers.dart';

class CanchaMapper {
  static jsonToEntity(Map<String, dynamic> json) => Cancha(
      idCancha: json['idCancha'],
      local: LocalMapper.jsonToEntity(json['local']),
      precio: json['precio'],
      descripcion: json['descripcion'],
      idImagen: json['idImagen'],
      estado: json['estado']);
}
