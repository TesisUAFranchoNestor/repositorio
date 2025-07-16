

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/cancha_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/cancha_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/cancha_respository_impl.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';


// Proveedor para obtener el accessToken como un Future<String?>
final accessTokenProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(loginProvider).user;
  if (user != null) {
    // Supongo que getIdToken es un método asíncrono que devuelve un Future<String?>
    return await user.getIdToken();
  } else {
    // Manejo de errores o si el usuario no está autenticado
    throw Exception('Usuario no autenticado');
  }
});

// Proveedor para el repositorio de Cancha
final canchasRepositoryProv = Provider<CanchaRepository>((ref)  {

  return CanchaRepositoryImpl(datasource: CanchaDatasourceImpl());
  
});