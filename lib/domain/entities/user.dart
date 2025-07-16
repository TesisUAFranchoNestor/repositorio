import 'package:mbarete_padel/domain/entities/entities.dart';

class User {
  
  final int id;
  final String correo;
  final int habilitado;
  final String role;
  final String ci;
  final String usuario;
  final String celular;
  final String nombre;
  final String uid;
  final Categoria? categoria;

  User({
    required this.id,
    required this.correo,
    required this.habilitado,
    required this.role,
    required this.ci,
    required this.usuario,
    required this.celular,
    required this.nombre,
    required this.uid,
    this.categoria
  });

}
