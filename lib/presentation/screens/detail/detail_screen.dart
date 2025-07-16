import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/presentation/providers/canchas/cancha_provider.dart';
import 'package:mbarete_padel/presentation/providers/horarios/horario_provider.dart';

class DetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'details';
  static String get routeLocation => '/$routeName';
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends ConsumerState<DetailScreen> {
  @override
  void initState() {
    super.initState();
    final canchasDisponibles = ref.read(canchaProvider.notifier).retornarCanchas();
    for (Cancha cancha in canchasDisponibles) {
      if (cancha.idCancha.toString() == widget.id) {
        ref.read(horarioProvider.notifier).listarHorarios(cancha.local.idLocal);
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final canchasDisponibles = ref.watch(canchaProvider);
    late Cancha canchaDatos;
    for (Cancha cancha in canchasDisponibles.canchas) {
      if (cancha.idCancha.toString() == widget.id) {
        canchaDatos = cancha;
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomSliverAppBar(cancha: canchaDatos),
          _CustomSliverPadding(cancha: canchaDatos)
        ],
      ),
      bottomNavigationBar:
          _CustomBottonNavigationBar(colors: colors, id: widget.id),
    );
  }
}

class _CustomSliverPadding extends ConsumerWidget {
  const _CustomSliverPadding({
    required this.cancha,
  });

  final Cancha cancha;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final horariosDisponibles = ref.watch(horarioProvider);

    return SliverPadding(
      padding: const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.map_rounded),
              const SizedBox(
                width: 16.0,
              ),
              Flexible(
                child: Text(
                  cancha.local.direccion,
                  overflow: TextOverflow.visible,
                  style: addressTextStyle2,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on),
              const SizedBox(
                width: 16.0,
              ),
              Flexible(
                child: Text(
                  "Gs. ${cancha.precio} / hora",
                  overflow: TextOverflow.visible,
                  style: addressTextStyle2,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            "Contacto:",
            style: subTitleTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Flexible(
                child: Text(
                  cancha.local.numTelefono,
                  overflow: TextOverflow.visible,
                  style: addressTextStyle2,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Turnos disponibles:",
                style: subTitleTextStyle,
              ),
              TextButton(
                  onPressed: () {}, child: const Text("Ver disponibilidad"))
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          if (horariosDisponibles.horarios.isNotEmpty)
            Column(
                children: horariosDisponibles.horarios
                    .map(
                      (horario) => Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Row(children: [
                            Text('${horario.nombre}: ',
                                style: addressTextStyle2.copyWith(fontWeight: FontWeight.w800)),
                            Text(
                              '${horario.horaInicio}:00 a ${horario.horaFin}:00 hs.',
                              style: descTextStyle,
                            )
                          ]),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                    .toList()),
          if (horariosDisponibles.horarios.isEmpty)
            const Center(child: CircularProgressIndicator(strokeWidth: 2,)),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Shimmer.fromColors(
            //           baseColor: Colors.grey.shade400,
            //           highlightColor: Colors.grey.shade500,
            //           child: const Icon(
            //         Icons.date_range_rounded,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 16.0,
            //     ),
            //     Flexible(
            //       child: Shimmer.fromColors(
            //           baseColor: Colors.grey.shade400,
            //           highlightColor: Colors.grey.shade500,
            //           child: Container(
            //               height: 20,
            //               width: MediaQuery
            //               .of(context)
            //               .size
            //               .width,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 color: Colors.white,
            //               ),
            //             )
            //         ),
            //     ),
            //   ],
            // ),


          const SizedBox(
            height: 32,
          ),
          Text(
            "Instalaciones:",
            style: subTitleTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          //FacilityCardList(facilities: field.facilities),
        ]),
      ),
    );
  }
}

class _CustomBottonNavigationBar extends StatelessWidget {
  const _CustomBottonNavigationBar({
    required this.colors,
    required this.id,
  });

  final ColorScheme colors;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.background, boxShadow: [
        BoxShadow(
          color: colors.secondary,
          offset: const Offset(0, 0),
          blurRadius: 10,
        ),
      ]),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 45),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          onPressed: () {
            context.push('/confirm/$id');
          },
          child: const Text("Reservar")),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Cancha cancha;

  const _CustomSliverAppBar({required this.cancha});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SliverAppBar(
      shadowColor: colors.primary.withOpacity(.2),
      backgroundColor: colors.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.4),
        statusBarIconBrightness: Brightness.light,
      ),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight * 1.2,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 1.0],
                  colors: [Colors.transparent, Colors.black54]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          child: Center(
            child: Text(
              cancha.local.nombre,
              style: titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        background: FadeIn(
          duration: const Duration(milliseconds: 1000),
          child: Image.network(
            '${Enviroment.apiURL}/imagen/obtener/${cancha.idImagen}',
            fit: BoxFit.cover,
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: colors.background,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 26,
              icon: const Icon(Icons.arrow_back)),
        ),
      ),
      actions: const [],
      expandedHeight: 300,
    );
  }
}


