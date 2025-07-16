
import 'package:mbarete_padel/domain/datasources/cancha_datasource.dart';
import 'package:mbarete_padel/domain/entities/cancha.dart';
import 'package:mbarete_padel/domain/repositories/cancha_repository.dart';

class CanchaRepositoryImpl extends CanchaRepository {

  final CanchaDatasource datasource;

  CanchaRepositoryImpl({required this.datasource});

  @override
  Future<List<Cancha>> listarCanchas( String accessToken ) {
    return datasource.listarCanchas(accessToken);
  }
  
}