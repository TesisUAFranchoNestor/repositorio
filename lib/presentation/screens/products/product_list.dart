
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/presentation/providers/productos/producto_local_provider.dart';
import 'package:mbarete_padel/presentation/providers/reservas/reserva_producto_provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductListView extends ConsumerStatefulWidget {
  static String get routeName => 'product-list';
  static String get routeLocation => '/$routeName';
  final String idReserva;
  final String idLocal;

  const ProductListView({
      super.key,
      required this.idReserva,
      required this.idLocal
    });

  @override
  ProductListViewState createState() => ProductListViewState();
}

class ProductListViewState extends ConsumerState<ProductListView> {
  @override
  void initState() {
    super.initState();
    ref.read(productoLocalProvider.notifier).listarProductos(int.parse(widget.idLocal), int.parse(widget.idReserva));
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final listaProductos = ref.watch(productoLocalProvider).listaProductos;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Agregar Productos'),
         toolbarHeight: kTextTabBarHeight,
         backgroundColor: colors.background,
         elevation: 0.0,
          centerTitle: true,
      ),
      body: listaProductos==null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2,),)
          : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: ListView.builder(
              itemCount: listaProductos.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                  return FadeInRight(child: _ItemProductoLocal(indice: index, idReserva: int.parse(widget.idReserva)));
              },
              ),
          ),
    );
  }
}

class _ItemProductoLocal extends ConsumerWidget {
  final int indice;
  final int idReserva;
  const _ItemProductoLocal({required this.indice, required this.idReserva});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    NumberFormat numberFormat = NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: 'Gs.');
    final listaProductos = ref.watch(productoLocalProvider).listaProductos;
    final productoLocal = listaProductos?[indice];
    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.white,
      child: SizedBox(
            height: 140,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(20)),
                child: SizedBox(
                  width: size.width*.20,
                  child: Image.network(
                      '${Enviroment.apiURL}/imagen/obtener/${productoLocal?.producto.idImagen}',
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
                  width: size.width*.55,
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Text(
                        productoLocal!.producto.titulo, 
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
                            (numberFormat.format(productoLocal.precio)) , 
                            style: addressTextStyleBlack,
                            ),
                        ],
                      ),
                      const Spacer(),
                      ItemCount(
                        initialValue: productoLocal.cantidad ?? 0,
                        minValue: 0,
                        maxValue: productoLocal.stock,
                        decimalPlaces: 0,
                        textStyle: const TextStyle(fontSize: 13, color: Colors.black),
                        buttonSizeHeight: 35,
                        buttonSizeWidth: 35,
                        step:1,
                        color: Colors.green.withOpacity(.4),
                        onChanged: (value) {
                          ref.read( productoLocalProvider.notifier ).aumentarCantidad(productoLocal.idProducto, value.ceil());
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: size.width*.10,
                  child: IconButton.filled(
                    onPressed: productoLocal.cantidad! <=0 
                    ? null
                    : (){
                          ref.read( reservaProductoProvider.notifier ).copiarValores(
                            idReserva: idReserva,
                            idProducto: productoLocal.idProducto,
                            idLocal: productoLocal.idLocal,
                            precioUnitario: productoLocal.precio,
                            cantidad: productoLocal.cantidad
                          );                    

                          ref.watch( reservaProductoProvider.notifier ).agregarProducto().then((success) {
                            if (success) {
                              _showSnackBar(context,'Se ha agregado el producto correctamente', true);
                              ref.read( productoLocalProvider.notifier ).eliminarItemLista(productoLocal.idProducto);
                              ref.read( reservaProductoProvider.notifier ).listarProductos(idReserva);
                            } else {
                              // Manejar el caso de reserva fallida, por ejemplo, mostrar un mensaje de error.
                              _showSnackBar(context,'Ha ocurrido un error al agregar producto');
                            }
                          }).catchError((error) {
                            // Manejar errores si ocurren durante la reserva.
                          });               
                    }, 
                    icon: const Icon(Icons.add)
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