
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/reserva_producto_repository.dart';
import 'package:mbarete_padel/presentation/providers/reservas/reserva_producto_repository_provider.dart';

final reservaProductoProvider  = StateNotifierProvider<ReservaProductoNotifier,ReservaProductoState>((ref) {
  final reservaRepo = ref.watch( reservaProductoRepositoryProvider );

  return ReservaProductoNotifier(reservaProductoRepository: reservaRepo);

});

class ReservaProductoNotifier extends StateNotifier<ReservaProductoState> {

  final ReservaProductoRepository reservaProductoRepository;

  ReservaProductoNotifier({
    required this.reservaProductoRepository
  }): super(ReservaProductoState());

  Future<List<ReservaProducto>?> listarProductos( int idReserva ) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<ReservaProducto>? lista = await reservaProductoRepository.listarProductos(idReserva, accessToken);
    if(lista!=null){
      state = state.copyWith(
        listaProductos: lista
      );
    }
    return lista;

  }

  Future<bool> agregarProducto() async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    final reservaLike = {
      'idReserva': state.idReserva, 
      'idProducto': state.idProducto,
      'idLocal': state.idLocal,
      'cantidad': state.cantidad,
      'precioUnitario': state.precioUnitario
    };

    final ReservaProducto? reserva = await reservaProductoRepository.crear(reservaLike, accessToken);
    
    return reserva==null ? false : true;
  }

  Future<bool> eliminarProducto( int idReserva, int idProducto) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    return await reservaProductoRepository.eliminar(idReserva, idProducto, accessToken);
    
  }


  void eliminarItemLista(int idProducto) {
    if (state.listaProductos != null) {
      final nuevaListaProductos = state.listaProductos!.where((producto) => producto.idProducto != idProducto).toList();
      state = state.copyWith(listaProductos: nuevaListaProductos);
    }
  }

  Timer? _debounceTimer;


  Future<bool?> aumentarCantidad(int idProducto, int idLocal, int cantidad) async {
    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    


    if (state.listaProductos != null) {
      final List<ReservaProducto> nuevaListaProductos = state.listaProductos!.map((producto) {
        if (producto.idProducto == idProducto) {

          state = state.copyWith(
            idReserva: producto.idReserva,
            idProducto: producto.idProducto,
            idLocal: idLocal,
            cantidad: cantidad,
            precioUnitario: producto.precioUnitario,
            isFormValid: true
          );
          return producto.copyWith(cantidad: cantidad);
        } else {
          return producto;
        }
      }).toList();

      state = state.copyWith(listaProductos: nuevaListaProductos);

        // Crear un Completer para manejar el valor de retorno del debouncer
      Completer<bool?> completer = Completer<bool?>();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
        bool ok = await agregarProducto();
        completer.complete(ok); // Completar el Completer con el valor devuelto por agregarProducto
      });

      return completer.future; // Devolver el futuro del Completer para obtener el valor de retorno del debouncer

    }else{
      return null;
    }

    
  }
  

  void copiarValores({int? idReserva, int? idProducto, int? idLocal, int? cantidad, double? precioUnitario}){

    state = state.copyWith(
      idReserva: idReserva,
      idProducto: idProducto,
      idLocal: idLocal,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      isFormValid: true
    );

  }

}



class ReservaProductoState {

  int? idReserva;
  int? idProducto;
  int? cantidad;
  double? precioUnitario;
  int? idLocal;
  bool? isFormValid;
  List<ReservaProducto>? listaProductos;

  ReservaProductoState({
      this.idReserva,
      this.idProducto,
      this.cantidad,
      this.precioUnitario,
      this.idLocal,
      this.isFormValid,
      this.listaProductos,
  });

  ReservaProductoState copyWith({
    int? idReserva,
    int? idProducto,
    int? cantidad,
    double? precioUnitario,
    int? idLocal,
    bool? isFormValid,
    List<ReservaProducto>? listaProductos,
    
  }) => ReservaProductoState(
    idReserva: idReserva ?? this.idReserva,
    idProducto: idProducto ?? this.idProducto,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    idLocal: idLocal ?? this.idLocal,
    isFormValid: isFormValid ?? this.isFormValid,
    listaProductos: listaProductos ?? this.listaProductos,
  );

}