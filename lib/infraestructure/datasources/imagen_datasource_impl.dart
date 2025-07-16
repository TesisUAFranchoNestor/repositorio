import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/domain/datasources/imagen_datasource.dart';


class ImagenDatasourceImpl extends ImagenDatasource {
  late Dio dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiURL,
  ));


  @override
  Future<String?> subirImagen(File imagen, String accessToken) async {
    FormData formData = FormData.fromMap({
      'imagen': await MultipartFile.fromFile(imagen.path, filename: 'imagen.jpg'), // Nombre del archivo y extensión
    });



    try {
        final response = await dio.post(
          '/imagen/subir',
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken', // Enviar el token de acceso si es necesario
            },
          ),
        );

        if (response.statusCode == 200) {
         return response.data['idImagen'] as String; // response.data ya es un Map
        } else {
          return null;
        }
    } catch (e) {
      return null;
    }


  }
}
