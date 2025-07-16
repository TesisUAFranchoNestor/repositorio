
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class ReservaFijaDatasource {

  Future<ReservaFija?> crearReservaFija( Map<String,dynamic> reservaLike, String accessToken );

  Future<ReservaFija?> obtenerReservaFija( int idReservaFija, String accessToken );

  Future<ReservaFija?> eliminarReserva(int? idReservaFija, String accessToken);


}