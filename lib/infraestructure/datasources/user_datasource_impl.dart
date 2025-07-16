
import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/user_datasource.dart';
import 'package:mbarete_padel/domain/entities/categoria.dart';
import 'package:mbarete_padel/domain/entities/user.dart';
import 'package:mbarete_padel/infraestructure/mappers/categoria_mapper.dart';
import 'package:mbarete_padel/infraestructure/mappers/user_mappers.dart';

class UserDatasourceImpl extends UserDatasource{

  late Dio dio = Dio (
    BaseOptions(
      baseUrl: Enviroment.apiURL,
    )
  );



  @override
  Future<User?> createUpdate(Map<String, dynamic> userLike, String accessToken ) async{
    try {
      final response = await dio.post(
        '/usuario/crear', 
        data: userLike,
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<User>?> listaUsuarios(String accessToken) async{
    try {
      final response = await dio.get(
        '/usuario/listar', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final lista = List<User>.from(
        response.data.map((x) => UserMapper.jsonToEntity(x)));
      return lista;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> cambiarAdmin(String? uuid, String accessToken) async{
    try {
      final response = await dio.get(
        '/usuario/set-admin/$uuid', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> habilitarUsuario(Map<String, dynamic> userLike, String accessToken) async{
    try {
      final response = await dio.post(
        '/usuario/habilitar', 
        data: userLike,
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> obtenerUsuario(int? idUsuario, String accessToken) async{
    try {
      final response = await dio.get(
        '/usuario/$idUsuario', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }

    @override
  Future<User?> obtenerUid(String? idUsuario, String accessToken) async{
    try {
      final response = await dio.get(
        '/usuario/uid/$idUsuario', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> quitarAdmin(String? uuid, String accessToken) async{
    try {
      final response = await dio.delete(
        '/usuario/remove-admin/$uuid', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Categoria>?> listarCategorias(String accessToken) async{
    try {
      final response = await dio.get(
        '/categoria/listar', 
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final lista = List<Categoria>.from(
        response.data.map((x) => CategoriaMapper.jsonToEntity(x)));
      return lista;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> cambiarCategoria(String? usuarioId, int? categoriaId, String accessToken) async{
    try {
      final userLike = {
                'usuarioId': usuarioId ?? '', 
                'categoriaId': categoriaId ?? 0, 
          }; 


      final response = await dio.post(
        '/usuario/actualizar-categoria', 
        data: userLike,
        options: Options( headers: { 'Authorization': 'Bearer $accessToken' })
        );
      final user = UserMapper.jsonToEntity(response.data);
      return user;
    } catch (e) {
      return null;
    }
  }



}