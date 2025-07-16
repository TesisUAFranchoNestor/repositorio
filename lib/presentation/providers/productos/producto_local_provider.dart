
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/producto_local_repository.dart';
import 'package:mbarete_padel/presentation/providers/productos/producto_local_repository_provider.dart';

final productoLocalProvider= StateNotifierProvider<ProductoLocalNotifier,ProductoLocalState>((ref) {
  final productoLocalRepo = ref.watch( productoLocalRepository );
  return ProductoLocalNotifier(productoLocalRepo);
});

class ProductoLocalNotifier extends StateNotifier<ProductoLocalState> {
  final ProductoLocalRepository productoLocalRepository;

  ProductoLocalNotifier
    (this.productoLocalRepository): 
    super(ProductoLocalState());

  Future<List<ProductoLocal>?> listarProductos( int idLocal, int idReserva ) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<ProductoLocal>? lista = await productoLocalRepository.listarProductos(idLocal, idReserva, accessToken);
    if(lista!=null){
      state = state.copyWith(
        listaProductos: lista
      );
    }
    return lista;

  }

  Future<List<ProductoLocal>?> listarProductosAdmin( int idLocal ) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<ProductoLocal>? lista = await productoLocalRepository.listarProductosAdmin(idLocal, accessToken);
    if(lista!=null){
      state = state.copyWith(
        listaProductos: lista
      );
    }
    return lista;

  }

  Future<bool> crearProducto() async {
  final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
  final productoLike = {
           'titulo': state.producto?.titulo ?? '', 
           'marca':  state.producto?.marca ?? '', 
           'descripcion': state.producto?.descripcion ?? '',
           'idImagen': state.producto?.idImagen ?? 0
    };  

    if (state.idProducto != null) {
      productoLike['idProducto'] = state.idProducto.toString();
    }

    final Producto? producto = await productoLocalRepository.crear(productoLike, accessToken);

    if(producto!=null) {
      onIdProductoChange(producto.idProducto);
    }

    return producto == null ? false : true;
  }

  Future<bool> crearProductoLocal() async {
  final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
  final productoLike = {
           'idProducto': state.idProducto?? '', 
           'idLocal':  1, 
           'precio': state.precio ?? 0,
           'stock': state.stock ?? 0
    };  

    final ProductoLocal? producto = await productoLocalRepository.crearProductoLocal(productoLike, accessToken);
    return producto == null ? false : true;
  }

  Future<bool> eliminarProductoLocal() async {
  final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
  final productoLike = {
           'idProducto': state.idProducto?? '', 
           'idLocal':  1, 
           'producto': {
              'idImagen': state.producto?.idImagen 
           }
    };  

    final ProductoLocal? producto = await productoLocalRepository.eliminarProductoLocal(productoLike, accessToken);
    return producto == null ? false : true;
  }

  Future<bool> obtenerProductoLocal(int? idProducto) async {
    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    final productoLike = {
           'idProducto': idProducto ?? 0, 
           'idLocal':  1, 
    };  

    final ProductoLocal? producto = await productoLocalRepository.obtenerProductoLocal(productoLike, accessToken);

    if(producto!=null){

      ProductoState? productoActual = state.producto ?? ProductoState();
      ProductoState productoActualizado = productoActual.copyWith(
        titulo: producto.producto.titulo,
        idImagen: producto.producto.idImagen,
        marca: producto.producto.marca,
        descripcion: producto.producto.descripcion
      );

      state = state.copyWith(
         idProducto: producto.idProducto,
         idLocal: producto.idLocal,
         precio: producto.precio,
         stock: producto.stock,
         producto: productoActualizado
      );


    }else{
      state = ProductoLocalState(
        idProducto: null,
        idLocal: null,
        precio: null,
        stock: null,
        producto: null,
      );
    }


    return producto == null ? false : true;
  }

  void onTituloChange(String? value) {
    ProductoState? productoActual = state.producto ?? ProductoState();
    ProductoState productoActualizado = productoActual.copyWith(titulo: value);
    state = state.copyWith(
      producto: productoActualizado,
    );
  }

  void onMarcaChange(String? value) {
    ProductoState? productoActual = state.producto ?? ProductoState();
    ProductoState productoActualizado = productoActual.copyWith(marca: value);
    state = state.copyWith(
      producto: productoActualizado,
    );
  }

  void onDescripcionChange(String? value) {
    ProductoState? productoActual = state.producto ?? ProductoState();
    ProductoState productoActualizado = productoActual.copyWith(descripcion: value);
    state = state.copyWith(
      producto: productoActualizado,
    );
  }

  void onIdImagenChange(int? value) {
    ProductoState? productoActual = state.producto ?? ProductoState();
    ProductoState productoActualizado = productoActual.copyWith(idImagen: value);
    state = state.copyWith(
      producto: productoActualizado,
    );
  }

  void onPrecioChange(double? value) {
    state = state.copyWith(
      precio: value,
    );
  }

  void onStockChange(int? value) {
    state = state.copyWith(
      stock: value,
    );
  }

  void onIdProductoChange(int? value) {
    state = state.copyWith(
      idProducto: value,
    );
  }

  void aumentarCantidad(int idProducto, int cantidad) {
    if (state.listaProductos != null) {
      final List<ProductoLocal> nuevaListaProductos = state.listaProductos!.map((producto) {
        if (producto.idProducto == idProducto) {
          return producto.copyWith(cantidad: cantidad);
        } else {
          return producto;
        }
      }).toList();

      state = state.copyWith(listaProductos: nuevaListaProductos);
    }
  }

  void eliminarItemLista(int idProducto) {
    if (state.listaProductos != null) {
      final nuevaListaProductos = state.listaProductos!.where((producto) => producto.idProducto != idProducto).toList();
      state = state.copyWith(listaProductos: nuevaListaProductos);
    }
  }

}



class ProductoLocalState {


  int? idProducto;
  int? idLocal;
  double? precio;
  int? stock;
  ProductoState? producto;
  List<ProductoLocal>? listaProductos;


  ProductoLocalState({
    this.idProducto,
    this.idLocal,
    this.precio,
    this.stock,
    this.producto,
    this.listaProductos
  });
    
  ProductoLocalState copyWith({
    int? idProducto,
    int? idLocal,
    double? precio,
    int? stock,
    ProductoState? producto,
    List<ProductoLocal>? listaProductos,
  }) => ProductoLocalState(
    idProducto: idProducto ?? this.idProducto,
    idLocal: idLocal ?? this.idLocal,
    precio: precio ?? this.precio,
    stock: stock ?? this.stock,
    producto: producto ?? this.producto,
    listaProductos: listaProductos ?? this.listaProductos,
  );


}

class ProductoState {
  


  final int? idProducto;
  final String? titulo;
  final String? marca;
  final String? descripcion;
  final int? idImagen;

  ProductoState({
    this.idProducto, 
    this.titulo, 
    this.marca, 
    this.descripcion,
    this.idImagen
  });

  ProductoState copyWith({
    int? idProducto,
    String? titulo,
    String? marca,
    String? descripcion,
    int? idImagen,
  }) => ProductoState(
    idProducto: idProducto ?? this.idProducto,
    titulo: titulo ?? this.titulo,
    marca: marca ?? this.marca,
    descripcion: descripcion ?? this.descripcion,
    idImagen: idImagen ?? this.idImagen,
  );
 
  

}
