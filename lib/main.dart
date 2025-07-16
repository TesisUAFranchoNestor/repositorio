import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/router/app_router.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/firebase_config.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  await Enviroment.initEnviroment();

  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseConfig.initializeFirebase(); // Inicializar Firebase

  runApp(const ProviderScope(child: MainApp()));

}



class MainApp extends ConsumerWidget {
  const MainApp({super.key});

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final AppTheme appTheme = ref.watch( themeNotifierProvider(isDarkMode) );


    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) return;
      ref.read( loginProvider.notifier ).onUserChanged(user);
    });

    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp.router(
        localizationsDelegates: const [
          
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          
        ],
        supportedLocales: const [
          Locale('es'),
        ],
        locale: const Locale('es'),
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
        theme: appTheme.getTheme(),
      ),
    );
  }
}
