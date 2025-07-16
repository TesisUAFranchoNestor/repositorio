import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/cancha_repository.dart';
import 'package:mbarete_padel/presentation/providers/canchas/canchas_repository_provider.dart';

final canchaProvider  = StateNotifierProvider<CanchaNotifier,CanchaState>((ref) {
  final canchaRepository = ref.watch( canchasRepositoryProv );

  return CanchaNotifier(canchaRepository: canchaRepository);

});

class CanchaNotifier extends StateNotifier<CanchaState> {

  final CanchaRepository canchaRepository;

  CanchaNotifier({
    required this.canchaRepository
  }): super(CanchaState(canchas: []));

  Future<List<Cancha>> listarCanchas() async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<Cancha> canchas = await canchaRepository.listarCanchas(accessToken);
    state = state.copyWith(canchas: canchas);
    return canchas;
  }

  List<Cancha> retornarCanchas(){
    return state.canchas;
  }


}


class CanchaState  {

  final List<Cancha> canchas;

  CanchaState({
    required this.canchas
  });
    
  CanchaState copyWith({
    required List<Cancha> canchas
  }) => CanchaState(
    canchas: canchas
  );

}