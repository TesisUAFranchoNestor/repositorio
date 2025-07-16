

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/admin/drawer_admin.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> 
    with AutomaticKeepAliveClientMixin {

Future<void> getToken() async {
    String firebaseIdToken = await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
     while (firebaseIdToken.isNotEmpty) {
      int startTokenLength =
          (firebaseIdToken.length >= 500 ? 500 : firebaseIdToken.length);
      //print('TokenPart: ${firebaseIdToken.substring(0, startTokenLength)}');
      int lastTokenLength = firebaseIdToken.length;
      firebaseIdToken =
          firebaseIdToken.substring(startTokenLength, lastTokenLength);
    }
  }
  @override
  void initState() {
    super.initState();
    ref.read( canchaProvider.notifier ).listarCanchas();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    

    //getToken();
    
    final canchasDisponibles = ref.watch( canchaProvider );

    final user = ref.watch( loginProvider );

    return  Scaffold(
      appBar: user.role=='ROLE_ADMIN' 
      ? AppBar(
        title: const Text('Admin User'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        )
      )
      : null,
      drawer:user.role=='ROLE_ADMIN' 
      ? const DrawerAdmin()
      : null,
    
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    "Qué jugamos hoy?",
                    style: greetingTextStyle,
                  ),
                ),
                //CategoryListView(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Canchas disponibles",
                        style: subTitleTextStyle,
                      ),
                      TextButton(
                          onPressed: () {
                            
                          },
                          child: const Text(''))
                    ],
                  ),
                ),
                // RECOMMENDED FIELDS
                if(canchasDisponibles.canchas.isNotEmpty)
                //if(1!=1)
                Column(
                    children: canchasDisponibles.canchas
                        .map((cancha) => 
                          SportFieldCard(
                                cancha: cancha,
                              ),
                        )
                        .toList()),
                if(canchasDisponibles.canchas.isEmpty)
                //if(1==1) 
                Column(
                    children: [
                        _SportFieldCardEmpty()
                    ]
                )
              ],
            ),
          )
        ],
      ),
    );
  }
    @override
    bool get wantKeepAlive => true;
  }

 
  

class _SportFieldCardEmpty extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
          right: 16, left: 16, top: 4.0, bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), color: colors.background,
              boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.1), blurRadius: 20,)]
          ),
          child: Column(
            children: [
              Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.shade600,
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    color: Colors.grey,
                    height: 200,
                    width: MediaQuery
                          .of(context)
                          .size
                          .width,
                  )
                ),
              ),
               Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                          height: 20,
                          width: MediaQuery
                          .of(context)
                          .size
                          .width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                          ),
                        )
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.grey.shade600,
                          child: Image.asset(
                            "assets/icons/pin.png",
                            width: 20,
                            height: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Flexible(
                          child: Shimmer.fromColors(
                          baseColor: Colors.grey,
                            highlightColor: Colors.grey.shade600,
                            child: Container(
                                height: 20,
                                width: MediaQuery
                                .of(context)
                                .size
                                .width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white,
                                ),
                              )
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}




 class _Header extends ConsumerWidget {  
    @override
    Widget build(BuildContext context, WidgetRef ref ) {
      final userCredential = ref.watch( loginProvider );

      final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        // SEARCH Icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                FadeInLeft(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                      userCredential.user!.photoURL==null
                      ?  const FadeInImage(
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/loader.gif'),
                      image: AssetImage("assets/images/user_profile_example.png"))
                      : FadeInImage(
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        placeholder: const AssetImage('assets/images/loader.gif'),
                        image: NetworkImage(userCredential.user!.photoURL ?? ''),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/user_profile_example.png", // Imagen de respaldo
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenido de vuelta",
                      style: descTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      (userCredential.user?.displayName != null && userCredential.user!.displayName!.length > 22)
                          ? '${userCredential.user!.displayName!.substring(0, 22)}...'
                          : (userCredential.user?.displayName ?? ''),
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16)),
              child: IconButton(
                onPressed: () async=> showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('Deseas cerrar sesión?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 500));
                            ref.read(loginProvider.notifier).signOut();
                        },
                        child: const Text('Aceptar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancelar'),
                        child: const Text('Cancelar'),
                      ),
                    ],
                )),
                icon: const Icon(Icons.logout_outlined, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
    }
  }