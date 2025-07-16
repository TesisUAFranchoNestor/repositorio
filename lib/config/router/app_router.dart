import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/main.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/screens/admin/lista_usuarios_screen.dart';
import 'package:mbarete_padel/presentation/screens/detail/checkout_screen.dart';
import 'package:mbarete_padel/presentation/screens/detail/detail_screen.dart';
import 'package:mbarete_padel/presentation/screens/screens.dart';


//final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: SplashScreen.routeLocation,
    routes: [
      GoRoute(
        path: SplashScreen.routeLocation,
        name: SplashScreen.routeName,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '${HomeScreen.routeLocation}/:page',
        name: HomeScreen.routeName,
        builder: (context, state) {
          final int pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
        },
      ),
      GoRoute(
        path: LoginScreen.routeLocation,
        name: LoginScreen.routeName,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: RegisterScreen.routeLocation,
        name: RegisterScreen.routeName,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: ResetPasswordScreen.routeLocation,
        name: ResetPasswordScreen.routeName,
        builder: (context, state) {
          return const ResetPasswordScreen();
        },
      ),
      GoRoute(
        path: CalendarScreen.routeLocation,
        name: CalendarScreen.routeName,
        builder: (context, state) {
          return const CalendarScreen();
        },
      ),
      GoRoute(
        path: '${DetailScreen.routeLocation}/:id',
        name: DetailScreen.routeName,
        builder: (context, state) {
          return DetailScreen(id: state.pathParameters['id'] ?? 'no-id',);
        },
      ),
      GoRoute(
        path: '${CheckoutScreen.routeLocation}/:id',
        name: CheckoutScreen.routeName,
        builder: (context, state) {
          return CheckoutScreen(id: state.pathParameters['id'] ?? 'no-id',);
        },
      ),
      GoRoute(
        path: '${SuccessScreen.routeLocation}/:id',
        name: SuccessScreen.routeName,
        builder: (context, state) {
          return SuccessScreen(id: state.pathParameters['id'] ?? 'no-id',);
        },
      ),
      GoRoute(
        path: '${ReservationsConfirmView.routeLocation}/:id',
        name: ReservationsConfirmView.routeName,
        builder: (context, state) {
          return ReservationsConfirmView(idReserva: state.pathParameters['id'] ?? '-99',);
        },
      ),
      GoRoute(
        path: '${ProductListView.routeLocation}/:idReserva/:idLocal',
        name: ProductListView.routeName,
        builder: (context, state) {
          return ProductListView(idReserva: state.pathParameters['idReserva'] ?? '-99', idLocal: state.pathParameters['idLocal'] ?? '-99',);
        },
      ),
      GoRoute(
        path: '${ReservaFijaScreen.routeLocation}/:idReserva',
        name: ReservaFijaScreen.routeName,
        builder: (context, state) {
          return ReservaFijaScreen(id: state.pathParameters['idReserva'] ?? '-99');
        },
      ),
      GoRoute(
        path: '${ProductScreen.routeLocation}/:id',
        name: ProductScreen.routeName,
        builder: (context, state) {
          return ProductScreen(id: state.pathParameters['id'] ?? '-99',);
        },
      ),
      GoRoute(
        path: ListaProductosScreen.routeLocation,
        name: ListaProductosScreen.routeName,
        builder: (context, state) {
          return const ListaProductosScreen();
        },
      ),
      GoRoute(
        path: ListaUsuariosScreen.routeLocation,
        name: ListaUsuariosScreen.routeName,
        builder: (context, state) {
          return const ListaUsuariosScreen();
        },
      ),
      GoRoute(
        path: '${UsuarioDetalleScreen.routeLocation}/:id',
        name: UsuarioDetalleScreen.routeName,
        builder: (context, state) {
          return UsuarioDetalleScreen(id: state.pathParameters['id'] ?? '-99',);
        },
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      if(state.location == RegisterScreen.routeLocation) return null;
      if(state.location == ResetPasswordScreen.routeLocation) return null;


      final isSplash = state.location == SplashScreen.routeLocation;
      if (isSplash) {
        return isAuth ? '${HomeScreen.routeLocation}/0' : LoginScreen.routeLocation;
      }

      final isLoggingIn = state.location == LoginScreen.routeLocation;
      if (isLoggingIn) return isAuth ? '${HomeScreen.routeLocation}/0' : null;


      return isAuth ? null : SplashScreen.routeLocation;
    },
  );
});