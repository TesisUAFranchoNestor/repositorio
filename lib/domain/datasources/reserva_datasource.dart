
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class ReservaDatasource {

  Future<Reserva?> reservar( Map<String,dynamic> reservaLike, String accessToken );
  
  Future<Reserva?> cancelar( int idReserva, String accessToken );

  Future<List<Reserva>?> reservasPorUsuario( int idUsuario, String accessToken );

  Future<Reserva?> reservaById( int idReserva, String accessToken );

  Future<List<Reserva>?> calendarioAdmin( int idCancha, String accessToken );

}