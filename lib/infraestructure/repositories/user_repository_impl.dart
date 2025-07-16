
import 'package:mbarete_padel/domain/datasources/user_datasource.dart';
import 'package:mbarete_padel/domain/entities/categoria.dart';
import 'package:mbarete_padel/domain/entities/user.dart';
import 'package:mbarete_padel/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository{

  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<User?> createUpdate(Map<String, dynamic> userLike, String accessToken ) async{
    return await datasource.createUpdate(userLike, accessToken);
  }
  
  @override
  Future<List<User>?> listaUsuarios(String accessToken) async{
    return await datasource.listaUsuarios(accessToken);
  }
  
  @override
  Future<User?> cambiarAdmin(String? uuid, String accessToken) async{
    return await datasource.cambiarAdmin(uuid, accessToken);
  }
  
  @override
  Future<User?> habilitarUsuario(Map<String, dynamic> userLike, String accessToken) async{
    return await datasource.habilitarUsuario(userLike, accessToken);
  }
  
  @override
  Future<User?> obtenerUsuario(int? idUsuario, String accessToken) async{
    return await datasource.obtenerUsuario(idUsuario, accessToken);
  }
  
  @override
  Future<User?> quitarAdmin(String? uuid, String accessToken) async{
    return await datasource.quitarAdmin(uuid, accessToken);
  }
  
  @override
  Future<User?> obtenerUid(String? idUsuario, String accessToken) async{
    return await datasource.obtenerUid(idUsuario, accessToken);

  }

  @override
  Future<List<Categoria>?> listarCategorias(String accessToken) async{
    return await datasource.listarCategorias(accessToken);
  }
  
  @override
  Future<User?> cambiarCategoria(String? usuarioId, int? categoriaId, String accessToken) async{
    return await datasource.cambiarCategoria(usuarioId, categoriaId, accessToken);
  }

}