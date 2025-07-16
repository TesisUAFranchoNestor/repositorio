import 'dart:io';

import 'package:mbarete_padel/domain/datasources/imagen_datasource.dart';
import 'package:mbarete_padel/domain/repositories/imagen_repository.dart';

class ImagenRepositoryImpl extends ImagenRepository {

  final ImagenDatasource datasource;

  ImagenRepositoryImpl({required this.datasource});



  @override
  Future<String?> subirImagen(File imagen, String accessToken) async{
    return await datasource.subirImagen(imagen, accessToken);
  }

  
  
}