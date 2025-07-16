import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mbarete_padel/domain/repositories/user_repository.dart';
import 'package:mbarete_padel/infraestructure/inputs/inputs.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/services/key_value_storage_service.dart';
import 'package:mbarete_padel/presentation/services/key_value_storage_service_impl.dart';



final loginProvider  = StateNotifierProvider<AuthNotifier,AuthState>((ref) {

  final keyValueStorageService = KeyValueStorageServiceImpl();
  final userRepository = ref.watch( userRepositoryProvider );
  return AuthNotifier(
    keyValueStorageService: keyValueStorageService,
    userRepository: userRepository
  );

});



class AuthNotifier extends StateNotifier<AuthState> {

  final KeyValueStorageService keyValueStorageService;
  final UserRepository userRepository;

  AuthNotifier({
    required this.keyValueStorageService, 
    required this.userRepository
  }): super(AuthState());

void cleanForm(){
  state = state.copyWith(
      authStatus: AuthStatus.checking,
      errorMessage: '',
      isValid: true,
      email: const Email.pure(),
      password: const Password.pure(),
      userName: const UserName.pure(),
      isFormPosted: false,
      isPosting: false
    );
}

Future<UserCredential?> _register(String email, String password, String username) async {
    try {
      state = state.copyWith(isPosting: true);
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCred.user!.updateDisplayName(username);
      state = state.copyWith(isPosting: false);
      return userCred;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: _retornarMensajeFirebase(e.code),
          isFormPosted: false
      );
      
    } catch (e) {
     state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error, por favor intente de nuevo',
          isFormPosted: false
      );
    }
    return null;

  }

  Future<void> actualizarUsuario() async {
    final user =  FirebaseAuth.instance.currentUser;
    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    final userLike = {
        'correo': user?.email, 
        'nombre': user?.displayName,
        'uid': user?.uid,
        'fcmtoken' : fcmToken
      };
    final userBD = await userRepository.createUpdate(userLike, accessToken);
    if(userBD!=null){
      state = state.copyWith(
        idUsuario: userBD.id,
        role: userBD.role,
        user: user,
        authStatus: AuthStatus.authenticated,
      );

      if(userBD.habilitado==0){

        await FirebaseAuth.instance.signOut();
          state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
            errorMessage: 'Usuario bloqueado',
        );
      }

    }

  }

 Future<void> handleGoogleButtonClick() async {
    try {

      state = state.copyWith(isPosting: true);
      final UserCredential? user = await _signInWithGoogle();
      state = state.copyWith(isPosting: false);

      final String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (user != null) {
        final userLike = {
           'correo': user.user?.email, 
           'nombre': user.user?.displayName,
           'uid': user.user?.uid,
            'fcmtoken' : fcmToken

         };

        final accesToken = await user.user?.getIdToken() ?? '';

        final userBD = await userRepository.createUpdate(userLike, accesToken);

        if(userBD!=null && userBD.habilitado==1) {
            state = state.copyWith(
            user: user.user,
            authStatus: AuthStatus.authenticated,
            errorMessage: '',
            isValid: true,
            email: const Email.pure(),
            password: const Password.pure(),
            userName: const UserName.pure(),
            isFormPosted: false,
            idUsuario: userBD.id
          );
        } else {
          await FirebaseAuth.instance.signOut();

          state = state.copyWith(
            authStatus: AuthStatus.notAuthenticated,
            errorMessage: 'Ha ocurrido un error',
          );         
        }
        

        

      } else {
        state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
        );
      }
    } catch (e) {
      //print('SignInFailed $e');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
      );
    }
  }

  Future<void> handleSubmitButtonClick() async {
    try {

      _touchEveryFiel();
      if( !state.isValid ) return;

      state = state.copyWith(isPosting: true);
      final UserCredential? user = await _signInWithEmailPassword(state.email.value, state.password.value);
      state = state.copyWith(isPosting: false);

      if (user != null) {
        state = state.copyWith(
          user: user.user,
          authStatus: AuthStatus.authenticated,
          errorMessage: '',
          isValid: true,
          //email: const Email.pure(),
          password: const Password.pure(),
          userName: const UserName.pure(),
          isFormPosted: false
        );
      } else {
        
      }
    } catch (e) {
      //print('SignInFailed $e');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
      );
    }
  }

  Future<void> handleRegisterButtonClick() async {
    try {
      
      _touchEveryFieldRegister();
      if( !state.isValid ) return;

      state = state.copyWith(isPosting: true);
      final UserCredential? user = await _register(
        state.email.value, 
        state.password.value,
        state.userName.value
        );
      state = state.copyWith(isPosting: false);

      if (user != null) {
        state = state.copyWith(
          user: user.user,
          authStatus: AuthStatus.authenticated,
          errorMessage: '',
          isValid: true,
          email: const Email.pure(),
          password: const Password.pure(),
          userName: const UserName.pure(),
          isFormPosted: false
        );
      } else {
        
      }
    } catch (e) {
      //print('SignInFailed $e');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
      );
    }
  }

  Future<bool> handleResetPasswordButtonClick() async {
    try {
      
      _touchEveryFieldReset();
      if( !state.isValid ) return false;

      state = state.copyWith(isPosting: true);
      bool reset = await _resetPassword(state.email.value);
      state = state.copyWith(isPosting: false);

      if (reset) {
        state = state.copyWith(
          user: null,
          authStatus: AuthStatus.authenticated,
          errorMessage: 'reset-password',
          isValid: true,
          email: const Email.pure(),
          password: const Password.pure(),
          userName: const UserName.pure(),
          isFormPosted: true
        );
        return true;
      } else {
        state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
        );
      return false;
      }
    } catch (e) {
      //print('SignInFailed $e');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
      );
      return false;
    }
  }

  Future<UserCredential?> _signInWithEmailPassword(String email, String pass) async {
    try {
     final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      state = state.copyWith(isPosting: false);
      return response;
    }on FirebaseAuthException catch(e){
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: _retornarMensajeFirebase(e.code),
          isFormPosted: false
      );
    } catch (e) {
      //print('SignInFailed ${e}');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
      );
      throw Exception('SignInFailed $e');
    }
    return null;
  }

  Future<bool> _resetPassword( String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }on FirebaseAuthException catch(e){
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: _retornarMensajeFirebase(e.code),
          isFormPosted: false
      );
      return false;
    } catch (e) {
      //print('SignInFailed ${e}');
      state = state.copyWith(
          authStatus: AuthStatus.notAuthenticated,
          errorMessage: 'Ha ocurrido un error',
          isFormPosted: false
      );
      return false;
    }
  }

  _touchEveryFiel() {

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([ email, password ])
    );
  }

    _touchEveryFieldReset() {

    final email = Email.dirty(state.email.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      isValid: Formz.validate([ email ])
    );
  }

  _touchEveryFieldRegister() {

    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final userName = UserName.dirty(state.userName.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      userName: userName,
      isValid: Formz.validate([ email, password, userName ])
    );
  }
  
  int retornarIdUsuario() {
    return state.idUsuario; 
  }

  String _retornarMensajeFirebase(String code){
    String error='';
    switch (code) {
      case 'invalid-email':
        error='Correo con formato inválido';
        break;
      case 'invalid-credential':
        error='Credenciales incorrectas';
        break;
      case 'email-already-in-use':
        error='El correo ingresado ya existe';
      case 'weak-password':
        error='La contraseña ingresada es muy débil.';
      default:
        error='Ha ocurrido un error';
    }

    return error;
  }



 Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      //print('Usuario registrado correctamente');

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      //print('SignInFailed $e');
      throw Exception('SignInFailed $e');
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      state = state.copyWith(
        errorMessage: '',
        isFormPosted: false,
        isPosting: false,
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> updatePhotoProfile(String photoUrl) async {
    try {

      state = state.copyWith(isLoadingPhoto: true);
      FirebaseStorage storage = FirebaseStorage.instance;
      String imageName = photoUrl.split('/').last;
      Reference ref = storage.ref().child(imageName);
      var storedImage = File(photoUrl);
      UploadTask uploadTask = ref.putFile(storedImage);
      await uploadTask.then((res) async {
        photoUrl = await res.ref.getDownloadURL();
      });

      await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUrl);
      User? user = FirebaseAuth.instance.currentUser;
      state = state.copyWith(user: user);
      state = state.copyWith(isLoadingPhoto: false);


      return true;
    } on Exception catch (_) {
      state = state.copyWith(isLoadingPhoto: false);
      return false;
    }
  }

  onPasswordChanged( String value ){
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      errorMessage: '',
      isFormPosted: false,
      isPosting: false,
    );
  }

  onEmailChanged( String value ){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      errorMessage: '',
      isFormPosted: false,
      isPosting: false,
    );
  }

  onUserChanged( User? user ){
    state = state.copyWith(
      user: user,
      errorMessage: '',
      isFormPosted: false,
      isPosting: false,
    );
  }

  onUserNameChanged( String value ){
    final newUserName = UserName.dirty(value);
    state = state.copyWith(
      userName: newUserName,
      errorMessage: '',
      isFormPosted: false,
      isPosting: false,
    );
  }


  

}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final Password password;
  final Email email;
  final UserName userName;
  final String errorMessage;
  final bool isValid;
  final bool isPosting;
  final bool isFormPosted;
  final int idUsuario;
  final bool isLoadingPhoto;
  final String role;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = '',
    this.password = const Password.pure(),
    this.email = const Email.pure(),
    this.userName = const UserName.pure(),
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
    this.idUsuario = -1,
    this.isLoadingPhoto = false,
    this.role = 'ROLE_USER'
  });  
  
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
    Email? email,
    Password? password,
    UserName? userName,
    bool? isValid,
    bool? isPosting,
    bool? isFormPosted,
    int? idUsuario,
    bool? isLoadingPhoto,
    String? role,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
    email: email ?? this.email,
    password:  password ?? this.password,
    userName: userName ?? this.userName,
    isValid:  isValid ?? this.isValid,
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    idUsuario: idUsuario ?? this.idUsuario,
    isLoadingPhoto: isLoadingPhoto ?? this.isLoadingPhoto,
    role: role ?? this.role
  );

}