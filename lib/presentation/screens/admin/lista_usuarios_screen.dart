import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/productos/producto_local_provider.dart';
import 'package:mbarete_padel/presentation/providers/user/user_provider.dart';

class ListaUsuariosScreen extends ConsumerStatefulWidget {
  static String get routeName => 'admin/user-list';
  static String get routeLocation => '/$routeName';

  const ListaUsuariosScreen({Key? key}) : super(key: key);
  @override
  ListaUsuariosScreenState createState() => ListaUsuariosScreenState();
}

class ListaUsuariosScreenState extends ConsumerState<ListaUsuariosScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).listarUsers();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuarios"),
      ),
      body: users.listaUsers == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.listaUsers!.length,
              itemBuilder: (context, index) {
                final user = users.listaUsers![index];

                return ListTile(
                  title: Text(user.nombre),
                  subtitle: Text("Correo: ${user.correo} | Estado: ${user.habilitado == 1 ? "Habilitado" : "Deshabilitado"}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    // Navegar a la ventana de edición
                    final resultado = await context.push('/admin/user/${user.id}');
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
