
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/horario_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/horario_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/horario_repository_impl.dart';


final horariosRepositoryProvider = Provider<HorarioRepository>((ref)  {

  return HorarioRepositoryImpl(datasource: HorarioDatasourceImpl());
  
});