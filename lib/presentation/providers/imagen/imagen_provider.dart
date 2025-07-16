import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/repositories/imagen_repository.dart';
import 'package:mbarete_padel/presentation/providers/imagen/imagen_repository_provider.dart';

final imagenProvider  = StateNotifierProvider<ImagenNotifier,ImagenState>((ref) {
  final imagenRepo = ref.watch( imagenRepositoryProvider );

  return ImagenNotifier(imagenRepository: imagenRepo);

});

class ImagenNotifier extends StateNotifier<ImagenState> {

  final ImagenRepository imagenRepository;

  ImagenNotifier({
    required this.imagenRepository
  }): super(ImagenState());

  Future<String?> subirImagen(File? imagen) async {
    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    if(imagen==null) return null;

    final String? idImagen = await imagenRepository.subirImagen(imagen, accessToken);
    return idImagen;
  }


}


class ImagenState  {

  String? idImagen;
 

  ImagenState({
    this.idImagen,
  });
    
  ImagenState copyWith({
    String? idImagen,
  }) => ImagenState(
    idImagen: idImagen ?? this.idImagen,
  );

}