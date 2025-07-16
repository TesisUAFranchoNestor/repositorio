import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/categoria_mapper.dart';

class UserMapper {
  static jsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      correo: json['correo'] ?? '',
      habilitado: json['habilitado']  ?? '',
      role: json['role']  ?? '',
      ci: json['ci'] ?? '',
      usuario: json['usuario'] ?? '',
      celular: json['celular']  ?? '',
      nombre: json['nombre'] ,
      uid: json['uid']  ?? '',
      categoria: json['categoria'] !=null ? CategoriaMapper.jsonToEntity(json['categoria']) : null
  );
}
