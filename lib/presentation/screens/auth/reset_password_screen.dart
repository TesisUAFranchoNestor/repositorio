import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';


class ResetPasswordScreen extends ConsumerWidget {
  
  const ResetPasswordScreen({super.key});


  static String get routeName => 'reset-password';
  static String get routeLocation => '/$routeName';

showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
}

showSnackbarSuccess(BuildContext context, String message) {
    final textTheme  = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        message, 
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green.shade600, )
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
      if(next.errorMessage=='reset-password') {
        showSnackbarSuccess(context, 'Se ha enviado un correo para restablecer la contraseña');
      } else {
        showSnackbar( context, next.errorMessage );
      }
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
                  Text('Restablecer contraseña',style: textTheme.titleLarge,),
                  const SizedBox(height: 50),
                  AuthTextField(
                    title: 'Correo', 
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorMessage:  loginForm.isFormPosted ? loginForm.email.errorMessage : null,
                    onChanged: ref.read( loginProvider.notifier ).onEmailChanged,
                  ),
                  const SizedBox(height: 20),
                  _SubmitButton(isDarkMode: isDarkMode),
                  
                  SizedBox(height: height * .08),
                   _TextResetLabel(),
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


class _TextResetLabel extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return InkWell(
      onTap: () {
        
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Revisa tu correo y segui las indicaciones',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
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

  showSnackbarSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade600,)
    );
}
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
        onPressed:
       loginForm.isPosting 
              ? null
              : () async {
                  await ref.read( loginProvider.notifier ).handleResetPasswordButtonClick();
              }, 
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
          'Restablecer',
          style: TextStyle(fontSize: 20, color: Colors.white,),
        ),
      ),
      )
    );
  }
}