import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/horario_datasource.dart';
import 'package:mbarete_padel/domain/entities/horario.dart';
import 'package:mbarete_padel/infraestructure/mappers/horario_mappers.dart';

class HorarioDatasourceImpl extends HorarioDatasource {
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));

  @override
  Future<List<Horario>> listarHorario(int idLocal, String accessToken) async {
    final response = await dio.post('/horarios/listar',  
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'idLocal': idLocal});

    final lista = List<Horario>.from(
        response.data.map((x) => HorarioMapper.jsonToEntity(x)));

    return lista;
  }
  
  @override
  Future<List<Horario>> listarHorariosReserva(Map<String, dynamic> horarioReservaLike, String accessToken) async{
    final response = await dio.post('/reserva/horarios-disponibles',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: horarioReservaLike);

    final lista = List<Horario>.from(
        response.data.map((x) => HorarioMapper.jsonToEntity(x)));

    return lista;
  }
}
