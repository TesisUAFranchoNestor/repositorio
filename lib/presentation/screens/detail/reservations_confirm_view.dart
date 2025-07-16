import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/reserva.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/providers/reservas/reserva_producto_provider.dart';
import 'package:shimmer/shimmer.dart';


class ReservationsConfirmView extends ConsumerStatefulWidget {
  static String get routeName => 'reservations-confirm';
  static String get routeLocation => '/$routeName';
  final String idReserva;

  const ReservationsConfirmView({
    super.key,
    required this.idReserva
  });

  @override
  ReservationsConfirmViewState createState() => ReservationsConfirmViewState();
}

class ReservationsConfirmViewState extends ConsumerState<ReservationsConfirmView> {

  @override
  void initState() {
    super.initState();
     ref.read(reservaProvider.notifier).getReservaById(int.parse(widget.idReserva));
     ref.read(reservaProductoProvider.notifier).listarProductos(int.parse(widget.idReserva));

  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final reserva = ref.watch(reservaProvider).reserva;
   
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Detalles reservas'),
         toolbarHeight: kTextTabBarHeight,
         backgroundColor: colors.background,
         elevation: 0.0,
          centerTitle: true,
      ),
      body: reserva==null 
       ? const Center(child: CircularProgressIndicator(strokeWidth: 2,),)
       : _Contenido(colors: colors, reserva: reserva, idReserva: int.tryParse(widget.idReserva),)
    );
  }
}

class _Contenido extends ConsumerWidget {
  const _Contenido({
    required this.colors,
    required this.reserva,
    required this.idReserva
  });

  final ColorScheme colors;
  final Reserva reserva;
  final int? idReserva;
    void _cancelarReserva(BuildContext context, WidgetRef ref) async {
      // Mostrar cuadro de diálogo de confirmación

      int idUsuario =  ref.read(loginProvider.notifier).retornarIdUsuario();


      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cerrar sin cancelar
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirmar cancelación
                child: const Text('Sí'),
              ),
            ],
          );
        },
      );

      if (confirmacion == true) {
        final resultado = await ref.read(reservaProvider.notifier).cancelarReserva(idUsuario);

        // Usa un post-frame callback para garantizar que el contexto aún es válido
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (resultado) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reserva cancelada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            context.pushReplacement('/home/0'); // Regresa a la pantalla anterior
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al cancelar la reserva'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(reservaProductoProvider).listaProductos;
    final user = ref.watch( loginProvider );

    final DateFormat df = DateFormat("yyyy-MM-dd");
    final DateFormat df2 = DateFormat("EEEE, dd MMM yyyy", "es");
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
     child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Text(
                 "Cancha",
                 style: subTitleTextStyle,
               ),
               const SizedBox(
                 height: 8,
               ),
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                     border: Border.all(color: colors.primary.withOpacity(0.5), width: 2),
                     color: colors.primary.withOpacity(0.2),
                     borderRadius: BorderRadius.circular(16)),
                 child: Row(
                   children: [
                     const Icon(Icons.stadium),
                     const SizedBox(
                       width: 8,
                     ),
                     Text(reserva.cancha!.local.nombre),
                   ],
                 ),
               ),
               const SizedBox(
                 height: 32,
               ),

               Text(
                 "Fecha",
                 style: subTitleTextStyle,
               ),
               const SizedBox(
                 height: 8,
               ),
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                     border: Border.all(color: colors.primary.withOpacity(0.5), width: 2),
                     color: colors.primary.withOpacity(0.2),
                     borderRadius: BorderRadius.circular(16)),
                 child: Row(
                   children: [
                     const Icon(Icons.calendar_today_rounded),
                     const SizedBox(
                       width: 8,
                     ),
                     Text(df2.format( df.parse(reserva.fecha) )),
                   ],
                 ),
               ),
               const SizedBox(
                 height: 32,
               ),
               Text(
                 "Horario",
                 style: subTitleTextStyle,
               ),
               const SizedBox(
                 height: 8,
               ),
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                     border: Border.all(color: colors.primary.withOpacity(0.5), width: 2),
                     color: colors.primary.withOpacity(0.2),
                     borderRadius: BorderRadius.circular(16)),
                 child: Row(
                   children: [
                     const Icon(Icons.timer),
                     const SizedBox(
                       width: 8,
                     ),
                     Text(  '${reserva.horaInicio>9 ? '' : '0' }${reserva.horaInicio}:00 - ${reserva.horaFin>9 ? '' : '0' }${reserva.horaFin}:00 hs'   ),
                   ],
                 ),
               ),
               const SizedBox(
                 height: 32,
               ),
              user.role=='ROLE_ADMIN'  && reserva.estado==1
              ? ElevatedButton(
                onPressed: () => _cancelarReserva(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                  child: const Text('Cancelar Reserva' ),
                )
              : const SizedBox(),    
              if(reserva.estado!=2)           
               Row(
                 children: [
                   Text(
                     "Agregar Productos",
                     style: subTitleTextStyle,
                   ),
                   const Spacer(),
                   FilledButton.icon(
                    onPressed: (){
                      context.push('/product-list/${reserva.idReserva}/${reserva.cancha?.local.idLocal}');
                    },  
                    icon: const Icon(Icons.add), label: const Text('Agregar'),)
                 ],
               ),
              const SizedBox(
                 height: 10,
               ),
              productos!=null && productos.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5, // Altura máxima del ListView.builder
                    child: ListView.builder(
                      itemCount: productos.length,
                      physics: const BouncingScrollPhysics(), 
                      itemBuilder: (context, index) {
                        return FadeInRight(child: _ItemProductoLocal(indice: index,));
                      },
                    ),
                  ),
                )
              : const SizedBox(),
              ]
            )
         );
     }
}


class _ItemProductoLocal extends ConsumerWidget {
  final int indice;
  const _ItemProductoLocal({required this.indice});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    NumberFormat numberFormat = NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: 'Gs.');
    final productos = ref.watch(reservaProductoProvider).listaProductos;
    final reservaProducto = productos?[indice];
    final reserva = ref.watch(reservaProvider).reserva;

    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
            height: 135,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(20)),
                child: SizedBox(
                  width: size.width*.18,
                  child: Image.network(
                      '${Enviroment.apiURL}/imagen/obtener/${reservaProducto!.producto?.idImagen}',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                                return child;
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey.shade600,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                    ),
                ),
                ),
                const SizedBox(width: 7,),
                SizedBox(
                  width: size.width*.50,
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Text(
                        reservaProducto.producto!.titulo, 
                        style: subTitleTextStyleDark,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Precio: ', style: subTitleTextStyleDark,),
                          Text(
                            (numberFormat.format(reservaProducto.precioUnitario)) , 
                            style: addressTextStyleBlack,
                            ),
                        ],
                      ),
                      const Spacer(),
                      ItemCount(
                        initialValue: reservaProducto.cantidad,
                        minValue: 1,
                        maxValue: 10,
                        decimalPlaces: 0,
                        textStyle: const TextStyle(fontSize: 13, color: Colors.black),
                        buttonSizeHeight: 35,
                        buttonSizeWidth: 35,
                        step:1,
                        color: Colors.green.withOpacity(.4),
                        onChanged: (value) {
                          ref.read( reservaProductoProvider.notifier ).aumentarCantidad(reservaProducto.idProducto, 
                          reserva?.cancha!.local.idLocal ?? 1, value.ceil()).then((success) {
                            if (success!=null && success) {
                               _showSnackBar(context,'Se ha modificado la cantidad', true);
                            }else if(success!=null && !success){
                              _showSnackBar(context,'Ha ocurrido un error al modificar la cantidad');
                            } else {
                            }
                          }).catchError((error) {
                            // Manejar errores si ocurren durante la reserva.
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ref.watch( reservaProductoProvider.notifier ).eliminarProducto(reservaProducto.idReserva, reservaProducto.idProducto).then((success) {
                            if (success) {
                              _showSnackBar(context,'Se ha eliminado el producto correctamente', true);
                              ref.read( reservaProductoProvider.notifier ).eliminarItemLista(reservaProducto.idProducto);
                            } else {
                              // Manejar el caso de reserva fallida, por ejemplo, mostrar un mensaje de error.
                              _showSnackBar(context,'Ha ocurrido un error al agregar producto');
                            }
                          }).catchError((error) {
                            // Manejar errores si ocurren durante la reserva.
                          });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade300, // Color de fondo del botón
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
          ]
        ),
      )
      )
    );
  }

  void _showSnackBar(BuildContext context, String message, [bool error=false]) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();

    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      backgroundColor: error ? Colors.green.shade600  :  Colors.red.shade600
    ));
  }
}