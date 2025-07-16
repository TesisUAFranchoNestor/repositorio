
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class HorarioDatasource {

  Future<List<Horario>> listarHorario( int idLocal, String accessToken );
  Future<List<Horario>> listarHorariosReserva( Map<String,dynamic> horarioReservaLike, String accessToken );

}