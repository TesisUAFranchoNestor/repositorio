
import 'package:mbarete_padel/domain/datasources/reserva_fija_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva_fija.dart';
import 'package:mbarete_padel/domain/repositories/reserva_fija_repository.dart';

class ReservaFijaRepositoryImpl extends ReservaFijaRepository{

  final ReservaFijaDatasource datasource;

  ReservaFijaRepositoryImpl({required this.datasource});

  @override
  Future<ReservaFija?> crearReservaFija(Map<String, dynamic> reservaLike, String accessToken) async{
    return await datasource.crearReservaFija(reservaLike, accessToken);
  }

  @override
  Future<ReservaFija?> obtenerReservaFija(int idReservaFija, String accessToken) async{
    return await datasource.obtenerReservaFija(idReservaFija, accessToken);
  }
  
  @override
  Future<ReservaFija?> eliminarReserva(int? idReservaFija, String accessToken) async{
    return await datasource.eliminarReserva(idReservaFija, accessToken);
  }

}