
import 'package:mbarete_padel/domain/datasources/reserva_datasource.dart';
import 'package:mbarete_padel/domain/entities/reserva.dart';
import 'package:mbarete_padel/domain/repositories/reserva_repository.dart';

class ReservaRepositoryImpl extends ReservaRepository{

  final ReservaDatasource datasource;

  ReservaRepositoryImpl({required this.datasource});

  @override
  Future<Reserva?> reservar(Map<String, dynamic> reservaLike, String accessToken) async{
    return datasource.reservar(reservaLike, accessToken);
  }
  
  @override
  Future<List<Reserva>?> reservasPorUsuario(int idUsuario, String accessToken) {
    return datasource.reservasPorUsuario(idUsuario, accessToken);
  }
  
  @override
  Future<Reserva?> reservaById(int idReserva, String accessToken) async{
    return datasource.reservaById(idReserva, accessToken);
  }
  
  @override
  Future<List<Reserva>?> calendarioAdmin(int idCancha, String accessToken) async {
    return datasource.calendarioAdmin( idCancha, accessToken );
  }
  
  @override
  Future<Reserva?> cancelar(int idReserva, String accessToken) async{
    return datasource.cancelar(idReserva, accessToken);
  }

}