import 'package:mbarete_padel/domain/entities/entities.dart';

class CategoriaMapper {
  static jsonToEntity(Map<String, dynamic> json) => Categoria(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      nivel: json['nivel'] ?? 0
  );
}
