import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class CanchaRepository {

  Future<List<Cancha>> listarCanchas( String accessToken );

}