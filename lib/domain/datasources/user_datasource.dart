import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class UserDatasource {

  Future<User?> createUpdate( Map<String,dynamic> userLike, String accessToken );

  Future<User?> obtenerUsuario( int? idUsuario, String accessToken );
  
  Future<User?> obtenerUid( String? idUsuario, String accessToken );

  Future<User?> habilitarUsuario( Map<String,dynamic> userLike, String accessToken );

  Future<User?> cambiarAdmin( String? uuid, String accessToken );

  Future<User?> quitarAdmin( String? uuid, String accessToken );

  Future<List<User>?> listaUsuarios(String accessToken );

  Future<List<Categoria>?> listarCategorias(String accessToken );

  Future<User?> cambiarCategoria( String? usuarioId, int? categoriaId, String accessToken );

}