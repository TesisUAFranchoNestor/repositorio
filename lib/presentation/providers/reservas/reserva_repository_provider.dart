
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/reserva_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/reserva_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/reserva_repository_impl.dart';


final reservaRepositoryProvider = Provider<ReservaRepository>((ref)  {

  return ReservaRepositoryImpl(datasource: ReservaDatasourceImpl());
  
});