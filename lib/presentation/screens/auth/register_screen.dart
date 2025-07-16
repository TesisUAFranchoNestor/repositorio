import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';


class RegisterScreen extends ConsumerWidget {
  
  const RegisterScreen({super.key});


  static String get routeName => 'register';
  static String get routeLocation => '/$routeName';

showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
}
  
 @override
  Widget build(BuildContext context, WidgetRef ref) {

    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final loginForm = ref.watch( loginProvider );

    ref.listen(loginProvider, (previous, next) { 
      if(next.errorMessage.isEmpty) return;
      showSnackbar( context, next.errorMessage );
    });
    
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const CustomBackground(),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  Text('Registrarse',style: textTheme.titleLarge,),
                  const SizedBox(height: 50),
                  AuthTextField(
                    title: 'Nombre del Usuario', 
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.person_2_rounded),
                    errorMessage:  loginForm.isFormPosted ? loginForm.userName.errorMessage : null,
                    onChanged: ref.read( loginProvider.notifier ).onUserNameChanged,
                  ),
                  AuthTextField(
                    title: 'Correo', 
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorMessage:  loginForm.isFormPosted ? loginForm.email.errorMessage : null,
                    onChanged: ref.read( loginProvider.notifier ).onEmailChanged,
                  ),
                  AuthTextField(
                    title: 'Contraseña', 
                    isPassword: true,
                    prefixIcon: const Icon(Icons.key_outlined),
                    errorMessage:  loginForm.isFormPosted ? loginForm.password.errorMessage : null,
                    onChanged: ref.read( loginProvider.notifier ).onPasswordChanged,
                  ),
                  const SizedBox(height: 20),
                  _SubmitButton(isDarkMode: isDarkMode),
                  
                  SizedBox(height: height * .08),
                   _LoginAccountLabel(),
                  
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _BackButton()),
        ],
      ),
    ));
  }


}


class _BackButton extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read( loginProvider.notifier ).cleanForm();
        context.push('/login');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left),
            ),
            const Text('Atrás',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
class _LoginAccountLabel extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ya tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                ref.read( loginProvider.notifier ).cleanForm();
                context.push('/login');
              },
              child: Text(
                'Ingresar',
                style: TextStyle(
                    color: colors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  final bool isDarkMode;

  const _SubmitButton({required this.isDarkMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   const radius = Radius.circular(10);
    final colors = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginProvider);

    return loginForm.isPosting
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            )
          : SizedBox(
      width: double.infinity,
      height: 60,
      child:FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: colors.primary,
          shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius)
        )),
        onPressed: loginForm.isPosting 
              ? null
              : ref.read( loginProvider.notifier ).handleRegisterButtonClick, 
        child: Container(
        
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: isDarkMode ? Colors.black45 : Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff44d62c), Color.fromARGB(255, 41, 160, 23)])),
        child: const Text(
          'Registrarme',
          style: TextStyle(fontSize: 20, color: Colors.white,),
        ),
      ),
      )
    );
  }
}