import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/reserva_producto_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/reserva_producto_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/reserva_producto_repository_impl.dart';

final reservaProductoRepositoryProvider = Provider<ReservaProductoRepository>((ref)  {

  return ReservaProductoRepositoryImpl(datasource: ReservaProductoDatasourceImpl());
  
});