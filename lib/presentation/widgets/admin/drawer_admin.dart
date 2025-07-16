import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/presentation/providers/auth/login_provider.dart';

class DrawerAdmin extends ConsumerWidget {
  const DrawerAdmin({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final userCredential = ref.watch( loginProvider );

    return Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colors.primary,
            ),
            child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    (userCredential.user?.displayName != null && userCredential.user!.displayName!.length > 10)
                          ? '${userCredential.user!.displayName!.substring(0, 10)}...'
                          : (userCredential.user?.displayName ?? '')
                    , style: subTitleTextStyle.copyWith(color: Colors.white),),
                    const SizedBox(height: 4,),
                    Text(
                      (userCredential.user?.email != null && userCredential.user!.email!.length > 17)
                          ? '${userCredential.user!.email!.substring(0, 16)}...'
                          : (userCredential.user?.email ?? '')
                      
                      , style: addressTextStyle.copyWith(color: Colors.white),overflow: TextOverflow.ellipsis,),
                  ],
                )
              ]
            ),
              
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
            ),
            title: const Text('Reservas'),
            onTap: () {
              context.push('/calendar');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_today,
            ),
            title: const Text('Reservas Fijas'),
            onTap: () {
              context.push('/reserva-fija/-99');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.sports_tennis,
            ),
            title: const Text('Productos'),
            onTap: () {
              context.push('/admin/product-list');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.people,
            ),
            title: const Text('Usuarios'),
            onTap: () {
              context.push('/admin/user-list');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.stadium,
            ),
            title: const Text('Canchas'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Local'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}