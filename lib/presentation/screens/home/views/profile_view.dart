import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/categoria.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/services/camera_gallery_service_impl.dart';
import 'package:mbarete_padel/presentation/widgets/shared/custom_toolbar_shape.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends ConsumerState<ProfileView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _initialize();
  }



Future<void> _initialize() async {
  try {
    String? firebaseIdToken = FirebaseAuth.instance.currentUser?.uid;
    if (firebaseIdToken != null) {
      await ref.read(userProvider.notifier).obtenerUid(firebaseIdToken);
      await ref.read(userProvider.notifier).listarCategorias();
    }
  } catch (e) {
   // print("Error al inicializar: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              child: _Body(),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Body extends ConsumerWidget {
  

Future<void> _showEditCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    String currentCategory,
    String? usuarioId,
    List<Categoria> categorias) async {
  
  String? selectedCategoryId;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccionar Categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categorias.map((categoria) {
            return RadioListTile<String>(
              title: Text(categoria.nombre),
              value: categoria.id.toString(),
              groupValue: selectedCategoryId,
              onChanged: (value) async {
                final navigator = Navigator.of(context); // Guardamos la referencia antes del await

                selectedCategoryId = value;
                int? categoriaId = int.tryParse(value!);

                if (categoriaId != null) {
                  bool resultado = await ref.read(userProvider.notifier).cambiarCategoria(usuarioId, categoriaId);

                  if (navigator.mounted) {
                    ScaffoldMessenger.of(navigator.context).showSnackBar(
                      SnackBar(content: Text(resultado
                          ? 'Categoría actualizada correctamente'
                          : 'Error al actualizar la categoría')),
                    );
                  }
                }

                if (navigator.mounted) {
                  navigator.pop(); // Cerrar el diálogo
                }
              },
            );
          }).toList(),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userCredential = ref.watch(loginProvider);
    final usuario = ref.watch(userProvider);

    final categorias = usuario.listaCategorias ?? []; // Asegurar que no sea null



    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
          ),
          Text(
            "Datos personales",
            style: subTitleTextStyle.copyWith(color: colors.primary),
          ),
 // Nueva sección: Categoría
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.category_outlined,
                    size: 24,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categoría",
                        style: descTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            usuario.user?.categoria == null  ? 'Sin categoría' : usuario.user!.categoria!.nombre ,
                            style: normalTextStyle,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: colors.primary),
                            onPressed: () =>_showEditCategoryDialog(
                              context,
                              ref,
                              usuario.user?.categoria?.nombre ?? 'Sin categoría',
                              usuario.user?.id.toString(),
                              categorias, // Pasamos la lista de categorías obtenida,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withOpacity(0.2)),
                  child: Icon(
                    Icons.verified_user_rounded,
                    size: 24,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Usuario",
                        style: descTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        userCredential.user?.displayName ?? '',
                        overflow: TextOverflow.visible,
                        style: normalTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withOpacity(0.2)),
                  child: Icon(
                    Icons.mail_outline_sharp,
                    size: 24,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Correo",
                        style: descTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        userCredential.user?.email ?? '',
                        overflow: TextOverflow.visible,
                        style: normalTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withOpacity(0.2)),
                  child: Icon(
                    Icons.mail_outline_sharp,
                    size: 24,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nro de Teléfono",
                        style: descTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        userCredential.user?.phoneNumber != null &&
                                userCredential
                                    .user!.phoneNumber!.isNotEmpty
                            ? userCredential.user?.phoneNumber ??
                                'No registrado'
                            : 'No registrado',
                        overflow: TextOverflow.visible,
                        style: normalTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(
            height: 16,
          ),
          Text(
            "Sobre la App",
            style: subTitleTextStyle.copyWith(color: colors.primary),
          ),
          InkWell(
            onTap: () {
              //_showSnackBar(context, "Newest Version");
            },
            splashColor: colors.primary.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 24,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mbarete Padel App",
                          style: normalTextStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Version 1.0.0",
                          style: descTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Cuenta",
            style: subTitleTextStyle.copyWith(color: colors.primary),
          ),
          InkWell(
            onTap: () async=> showDialog<String>(
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
              ),
            ),
            
            splashColor: colors.primary.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 24,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Cerrar Sesion",
                        style: normalTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCredential = ref.watch(loginProvider);

    final colors = Theme.of(context).colorScheme;
    return Container(
        color: Colors.transparent,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const CustomPaint(
                painter: CustomToolbarShape(lineColor: Colors.green),
              )),
          SafeArea(
              child: Column(
            children: [
              Text(
                "Cuenta",
                style: greetingTextStyle.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                     userCredential.isLoadingPhoto 
                     ? Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.grey.shade200,
                            child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                    height: 85,
                                    width: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                    )
                                  )
                            )
                          ),
                            const SizedBox(
                              height: 30,
                              width: 30,
                            )
                       ],
                     )
                     :
                      userCredential.user!.photoURL == null
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                FadeIn(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: const FadeInImage(
                                      height: 85,
                                      width: 85,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          AssetImage('assets/images/loader.gif'),
                                      image: AssetImage(
                                          "assets/images/user_profile_example.png"),
                                          
                                          
                                    )
                                    ),
                              ),
                              SizedBox(
                              height: 30,
                              width: 30,
                              child: IconButton.filled( 
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit_rounded), 
                                color: Colors.white, 
                                onPressed: () async{
                                  final photoPath = await CameraGalleryServiceImpl().selectPhoto();
                                  if( photoPath==null ) return;
                          
                                  ref.read( loginProvider.notifier )
                                    .updatePhotoProfile(photoPath);
                          
                                },
                                iconSize: 18,
                              ),
                            )
                            ]
                          )
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeIn(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage(
                                    height: 85,
                                    width: 85,
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        'assets/images/loader.gif'),
                                    image: NetworkImage(
                                        userCredential.user!.photoURL ?? ''),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/user_profile_example.png", // Imagen de respaldo
                                          height: 85,
                                          width: 85,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: IconButton.filled( 
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit_rounded), 
                                color: Colors.white, 
                                onPressed: () async{
                                  final photoPath = await CameraGalleryServiceImpl().selectPhoto();
                                  if( photoPath==null ) return;
                          
                                  ref.read( loginProvider.notifier )
                                    .updatePhotoProfile(photoPath);
                          
                                },
                                iconSize: 18,
                              ),
                            )
                          ]
                          ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userCredential.user?.displayName ?? '',
                            style:
                                subTitleTextStyle.copyWith(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: colors.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: colors.primary.withOpacity(0.2))),
                              child: Text(
                                userCredential.user?.email ?? '',
                                style: descTextStyle.copyWith(
                                    color: Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ))
        ]));
  }
}
