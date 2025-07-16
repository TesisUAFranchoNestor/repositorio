import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/categoria.dart';
import 'package:mbarete_padel/domain/entities/user.dart' as entities;
import 'package:mbarete_padel/domain/repositories/user_repository.dart';
import 'package:mbarete_padel/presentation/providers/user/user_repository_provider.dart';

final userProvider  = StateNotifierProvider<UserNotifier,UserState>((ref) {
  final userRepo = ref.watch( userRepositoryProvider );

  return UserNotifier(userRepository: userRepo);

});

class UserNotifier extends StateNotifier<UserState> {

  final UserRepository userRepository;

  UserNotifier({
    required this.userRepository
  }): super(UserState());


 

  Future<List<entities.User>?> listarUsers( ) async {

    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<entities.User>? lista = await userRepository.listaUsuarios(accessToken);
    if(lista!=null){
      state = state.copyWith(
        listaUsers: lista
      );
    }
    return lista;

  }

  Future<bool> deshabilitarUsuario(int? idUsuario) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final userLike = {
           'id': idUsuario ?? 0, 
           'habilitado':  0, 
    }; 
    final entities.User? user = await userRepository.habilitarUsuario(userLike, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }else{
      state = UserState(
        user: null
      );
    }
    return user == null ? false : true;
  }

Future<bool> cambiarCategoria(String? usuarioId, int? categoriaId) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    final entities.User? user = await userRepository.cambiarCategoria(usuarioId, categoriaId, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }else{
      state = UserState(
        user: null
      );
    }
    listarCategorias();
    return user == null ? false : true;
  }

  Future<bool> habilitarUsuario(int? idUsuario) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final userLike = {
           'id': idUsuario ?? 0, 
           'habilitado':  1, 
    }; 
    final entities.User? user = await userRepository.habilitarUsuario(userLike, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }
    
    return user == null ? false : true;
  }

  Future<bool> listarCategorias() async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';

    final List<Categoria>?  categorias = await userRepository.listarCategorias(accessToken);
    if(categorias!=null){
      state = state.copyWith(
         listaCategorias: categorias,
      );
    }
    return categorias == null ? false : true;
  }

  Future<bool> quitarRolAdministrador(String? uid) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final entities.User? user = await userRepository.quitarAdmin(uid, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }
    return user == null ? false : true;
  }

  Future<bool> cambiarRolAdministrador(String? uid) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final entities.User? user = await userRepository.cambiarAdmin(uid, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }
    return user == null ? false : true;
  }


  Future<bool> obtenerUsuario(int? idUsuario) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final entities.User? user = await userRepository.obtenerUsuario(idUsuario, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }else{
      state = UserState(
        user: null
      );
    }
    return user == null ? false : true;
  }

  Future<bool> obtenerUid(String? idUsuario) async {
    final accessToken =  await firebase_auth.FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final entities.User? user = await userRepository.obtenerUid(idUsuario, accessToken);
    if(user!=null){
      state = state.copyWith(
         user: user,
      );
    }else{
      state = UserState(
        user: null
      );
    }
    return user == null ? false : true;
  }
}
class UserState  {

  entities.User? user;
  List<entities.User>? listaUsers;
  List<Categoria>? listaCategorias;

  UserState({
    this.listaUsers,
    this.user,
    this.listaCategorias,
  });
    
  UserState copyWith({
    List<entities.User>? listaUsers,
    entities.User? user,
    List<Categoria>? listaCategorias
  }) => UserState(
   
    listaUsers: listaUsers ?? this.listaUsers,
    user: user ?? this.user,
    listaCategorias: listaCategorias
  );

}