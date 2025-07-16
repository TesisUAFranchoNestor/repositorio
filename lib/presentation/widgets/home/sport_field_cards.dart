
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:shimmer/shimmer.dart';

class SportFieldCard extends StatelessWidget {
  final Cancha cancha;

  const SportFieldCard({super.key, required this.cancha});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
          right: 16, left: 16, top: 4.0, bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push('/details/${cancha.idCancha}');
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), color: colors.background,
              boxShadow: [BoxShadow(
                  color: colors.primary.withOpacity(0.1), blurRadius: 20,)]
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: /*FadeInImage(
                  placeholder: const AssetImage('assets/images/loader.gif'), 
                  image: NetworkImage('${Enviroment.apiURL}/imagen/obtener/${cancha.idImagen}'),
                  height: 200,
                  placeholderFit: BoxFit.scaleDown,
                  width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  fit: BoxFit.cover
                    
                ),*/
                Image.network(
                  '${Enviroment.apiURL}/imagen/obtener/${cancha.idImagen}',
                  height: 200,
                  width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                          return child;
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                        height: 200,
                        width: MediaQuery
                        .of(context)
                        .size
                        .width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                      ),
          );

                  },

                )


              ),
               Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      cancha.local.nombre,
                      maxLines: 2,
                      style: subTitleTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/pin.png",
                          width: 20,
                          height: 20,
                          color: colors.primary,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Flexible(
                          child: Text(
                            cancha.local.direccion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: addressTextStyle,
                          ),
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
