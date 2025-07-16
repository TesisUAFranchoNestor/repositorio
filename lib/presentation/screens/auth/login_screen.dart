import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';


class LoginScreen extends ConsumerWidget {
  
  const LoginScreen({super.key});


  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

showSnackbar(BuildContext context, String message) {
    final textTheme  = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        message, 
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade600, )
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: SizedBox(
        height: height,
        child: Stack(
      
          children: <Widget>[
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    Image.asset(
                      isDarkMode ? 'assets/logo_dark.png' : 'assets/logo.png',
                      fit: BoxFit.cover,
                      height: 150
                    ),
                    const SizedBox(height: 50),
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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                            ref.read( loginProvider.notifier ).cleanForm();
                            context.push('/reset-password');
                        },
                        child: const Text('Olvidaste tu contraseña ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ),
                     _Divider(),
                     _GoogleSigInButton(),
                     _CreateAccountLabel(),
                  ],
                ),
              ),
            ),
           loginForm.isPosting ? CustomFullPageLoader(isDarkMode: isDarkMode): const SizedBox(),
          ],
          
        ),
      )),
    );
  }


}

class _Divider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

class _GoogleSigInButton extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final loginForm = ref.watch( loginProvider );
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding:  const EdgeInsets.only(bottom: 16.0),
      child: loginForm.isPosting
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            )
          :  OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () {
                ref.read( loginProvider.notifier ).handleGoogleButtonClick();
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Ingresar con Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}


class _CreateAccountLabel extends ConsumerWidget {

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
              'No tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                ref.read(loginProvider.notifier).cleanForm();
                context.push('/register');
              }, 
              child: Text(
                'Registrate',
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

    return /*loginForm.isPosting
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            )
          : */ SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: colors.primary,
          shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius)
        )),
        onPressed: loginForm.isPosting 
              ? null
              : () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read( loginProvider.notifier ).handleSubmitButtonClick();
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
          'Ingresar',
          style: TextStyle(fontSize: 20, color: Colors.white,),
        ),
      ),
      )
    );
  
  }
}