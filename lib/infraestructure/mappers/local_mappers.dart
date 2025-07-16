import 'package:mbarete_padel/domain/entities/entities.dart';

class LocalMapper {
  static jsonToEntity(Map<String, dynamic> json) => Local(
      idLocal: json['idLocal'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      numTelefono: json['numTelefono'],
      descripcion: json['descripcion'] ?? '',
      estado: json['estado']);
}
