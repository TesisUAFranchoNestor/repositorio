import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/productos/producto_local_provider.dart';

class ListaProductosScreen extends ConsumerStatefulWidget {
  static String get routeName => 'admin/product-list';
  static String get routeLocation => '/$routeName';

  const ListaProductosScreen({Key? key}) : super(key: key);
  @override
  ListaProductosScreenState createState() => ListaProductosScreenState();
}

class ListaProductosScreenState extends ConsumerState<ListaProductosScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(productoLocalProvider.notifier).listarProductosAdmin(1);
  }

  @override
  Widget build(BuildContext context) {
    final productosState = ref.watch(productoLocalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Productos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final resultado = await context.push('/product/-99');
              if (resultado == true) {
                ref.read(productoLocalProvider.notifier).listarProductosAdmin(1);
              }
            },
          ),
        ],
      ),
      body: productosState.listaProductos == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productosState.listaProductos!.length,
              itemBuilder: (context, index) {
                final producto = productosState.listaProductos![index];

                return ListTile(
                  title: Text(producto.producto.titulo),
                  subtitle: Text("Stock: ${producto.stock} | Precio: \$${producto.precio}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    // Navegar a la ventana de edición
                    final resultado = await context.push('/product/${producto.idProducto}');
                    if (resultado == true) {
                      ref.read(productoLocalProvider.notifier).listarProductosAdmin(1);
                    }
                  },
                );
              },
            ),
    );
  }
}
