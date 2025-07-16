
import 'dart:io';

abstract class ImagenDatasource {

  Future<String?> subirImagen(File imagen, String accessToken );

}