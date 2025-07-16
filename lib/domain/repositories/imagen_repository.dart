
import 'dart:io';

abstract class ImagenRepository {

  Future<String?> subirImagen(File imagen, String accessToken );

}