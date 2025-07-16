
import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/reserva_fija_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva_fija.dart';
import 'package:mbarete_padel/infraestructure/mappers/reserva_fija_mappers.dart';

class ReservaFijaDatasourceImpl extends ReservaFijaDatasource{
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));
  @override
  Future<ReservaFija?> crearReservaFija(Map<String, dynamic> reservaLike, String accessToken) async{
    try{
      final response = await dio.post('/reservas-fijas',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: reservaLike);
      final reserva =  ReservaFijaMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }

  @override
  Future<ReservaFija?> obtenerReservaFija(int idReservaFija, String accessToken) async{
    try{
      final response = await dio.get('/reservas-fijas/id/$idReservaFija',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      final reserva =  ReservaFijaMapper.jsonToEntity(response.data);
      return reserva;
      
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<ReservaFija?> eliminarReserva(int? idReservaFija, String accessToken) async{
    try{
      final response = await dio.delete('/reservas-fijas/remover/$idReservaFija',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      final reserva =  ReservaFijaMapper.jsonToEntity(response.data);
      return reserva;
      
    }catch(e){
      return null;
    }
  }

}