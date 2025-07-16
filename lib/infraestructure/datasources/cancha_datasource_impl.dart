import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/cancha_datasource.dart';
import 'package:mbarete_padel/domain/entities/cancha.dart';
import 'package:mbarete_padel/infraestructure/mappers/cancha_mappers.dart';

class CanchaDatasourceImpl extends CanchaDatasource {
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<List<Cancha>> listarCanchas(String accessToken) async {
    final response = await dio.get('/canchas/listar',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    final lista = List<Cancha>.from(
        response.data.map((x) => CanchaMapper.jsonToEntity(x)));

    return lista;
  }
}
