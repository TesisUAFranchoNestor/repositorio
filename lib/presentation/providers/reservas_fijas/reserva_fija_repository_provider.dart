
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/reserva_fija_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/reserva_fija_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/reserva_fija_repository_impl.dart';


final reservaFijaRepositoryProvider = Provider<ReservaFijaRepository>((ref)  {

  return ReservaFijaRepositoryImpl(datasource: ReservaFijaDatasourceImpl());
  
});