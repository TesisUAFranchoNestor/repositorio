
import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/reserva_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva.dart';
import 'package:mbarete_padel/infraestructure/mappers/reserva_mappers.dart';

class ReservaDatasourceImpl extends ReservaDatasource{
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));


  @override
  Future<Reserva?> reservar(Map<String, dynamic> reservaLike, String accessToken) async{
    try{
      final response = await dio.post('/reserva/reservar',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: reservaLike);
      final reserva =  ReservaMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
    

   
  }
  
  @override
  Future<List<Reserva>?> reservasPorUsuario(int idUsuario, String accessToken) async {
    try{
      final response = await dio.post('/reserva/usuario',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: {'idUsuario':idUsuario});

      final lista = List<Reserva>.from(
        response.data.map((x) => ReservaMapper.jsonToEntity(x)));
      return lista;
      
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<Reserva?> reservaById(int idReserva, String accessToken) async{
    try{
      final response = await dio.get('/reserva/id/$idReserva',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      final reserva =  ReservaMapper.jsonToEntity(response.data);
      return reserva;
      
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<List<Reserva>?> calendarioAdmin(int idCancha, String accessToken) async {
    try{
      final response = await dio.post('/reserva/calendario',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: {'idCancha':idCancha});

      final lista = List<Reserva>.from(
        response.data.map((x) => ReservaMapper.jsonToEntity(x)));
      return lista;
      
    }catch(e){
      return null;
    }
  }
  
  @override
  Future<Reserva?> cancelar(int idReserva, String accessToken) async {
    try{
      final response = await dio.get('/reserva/cancelar/$idReserva',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

      final reserva =  ReservaMapper.jsonToEntity(response.data);
      return reserva;
    }catch(e){
      return null;
    }
  }

}