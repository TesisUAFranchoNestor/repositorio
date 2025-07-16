
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/producto_local_repository.dart';
import 'package:mbarete_padel/infraestructure/datasources/producto_local_datasource_impl.dart';
import 'package:mbarete_padel/infraestructure/repositories/producto_local_repository_impl.dart';


final productoLocalRepository = Provider<ProductoLocalRepository>((ref)  {

  return ProductoLocalRepositoryImpl( ProductoLocalDatasourceImpl() );
  
});