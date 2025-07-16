
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/imagen_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/imagen_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/imagen_repository_impl.dart';


final imagenRepositoryProvider = Provider<ImagenRepository>((ref)  {

  return ImagenRepositoryImpl(datasource: ImagenDatasourceImpl());
  
});