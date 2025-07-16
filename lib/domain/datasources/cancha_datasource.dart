
import 'package:mbarete_padel/domain/entities/entities.dart';

abstract class CanchaDatasource {

  Future<List<Cancha>> listarCanchas( String accessToken );

}