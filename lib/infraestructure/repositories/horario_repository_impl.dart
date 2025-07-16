import 'package:mbarete_padel/domain/datasources/horario_datasource.dart';
import 'package:mbarete_padel/domain/entities/horario.dart';
import 'package:mbarete_padel/domain/repositories/horario_repository.dart';

class HorarioRepositoryImpl extends HorarioRepository {
  final HorarioDatasource datasource;

  HorarioRepositoryImpl({required this.datasource});

  @override
  Future<List<Horario>> listarHorario(int idLocal, String accessToken) async {
    return await datasource.listarHorario(idLocal, accessToken);
  }
  
  @override
  Future<List<Horario>> listarHorariosReserva(Map<String, dynamic> horarioReservaLike, String accessToken) async{
     return await datasource.listarHorariosReserva(horarioReservaLike, accessToken);
  }
}
