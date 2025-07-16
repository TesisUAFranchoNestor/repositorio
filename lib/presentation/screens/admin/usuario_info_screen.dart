import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/user.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';

class UsuarioDetalleScreen extends ConsumerStatefulWidget {
  static String get routeName => 'admin/user';
  static String get routeLocation => '/$routeName';
  final String id;

  const UsuarioDetalleScreen({super.key, required this.id});

  @override
  UsuarioDetalleState createState() => UsuarioDetalleState();
}

class UsuarioDetalleState extends ConsumerState<UsuarioDetalleScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).obtenerUsuario(int.tryParse(widget.id));
  }

  @override
  Widget build(BuildContext context) {

    final user = ref.watch( userProvider ).user;



    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${user?.nombre}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Correo: ${user?.correo}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estado: ${user?.habilitado == 1 ? "Habilitado" : "Deshabilitado"}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rol: ${user?.role == "ROLE_ADMIN" ? "Administrador" : "Usuario"}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if(user?.habilitado == 1 &&  user?.role != "ROLE_ADMIN")
            ElevatedButton(
              onPressed: () => _deshabilitarUsuario(ref, user),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              child: const Text('Deshabilitar Usuario'),
            ),
            if(user?.habilitado == 0)
            ElevatedButton(
              onPressed: () => _habilitarUsuario(ref, user),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              child: const Text('Habilitar Usuario'),
            ),
            const SizedBox(height: 10),
            user?.role != "ROLE_ADMIN"
            ?
            ElevatedButton(
              onPressed: () => _cambiarRolAdministrador(ref, user),
              child: const Text('Cambiar a Administrador'),
            )
            :
            ElevatedButton(
              onPressed: () => _quitarRolAdministrador(ref, user),
              child: const Text('Quitar Administrador'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deshabilitarUsuario(WidgetRef ref, User? user) async {
    final confirmacion = await _mostrarConfirmacion(
      context: ref.context,
      titulo: 'Deshabilitar Usuario',
      mensaje: '¿Estás seguro de que deseas deshabilitar a este usuario?',
    );
     // Check if the widget is still mounted before proceeding

    if (confirmacion) {
      final resultado = await ref
          .read(userProvider.notifier)
          .deshabilitarUsuario(user?.id); 
          if (mounted) {
            // Llamada al provider para deshabilitar
            _mostrarSnackbar(ref.context,
            resultado ? 'Usuario deshabilitado correctamente' : 'Error al deshabilitar usuario');
          }
    }
  }

  Future<void> _habilitarUsuario(WidgetRef ref, User? user) async {
    final confirmacion = await _mostrarConfirmacion(
      context: ref.context,
      titulo: 'Habilitar Usuario',
      mensaje: '¿Estás seguro de que deseas habilitar a este usuario?',
    );
    if (confirmacion) {
      final resultado = await ref
          .read(userProvider.notifier)
          .habilitarUsuario(user?.id); // Llamada al provider para deshabilitar
          if (mounted) {
              _mostrarSnackbar(ref.context,
                resultado ? 'Usuario habilitado correctamente' : 'Error al habilitado usuario');
          }
    }
  }

  Future<void> _cambiarRolAdministrador(WidgetRef ref, User? user) async {
    final confirmacion = await _mostrarConfirmacion(
      context: ref.context,
      titulo: 'Cambiar a Administrador',
      mensaje: '¿Estás seguro de que deseas otorgar rol de administrador?',
    );
    if (confirmacion) {
      final resultado = await ref
          .read(userProvider.notifier)
          .cambiarRolAdministrador(user?.uid);
          if (mounted) {
              _mostrarSnackbar(ref.context,
              resultado ? 'Usuario ahora es administrador' : 'Error al cambiar rol');
          }
    }
  }

  Future<void> _quitarRolAdministrador(WidgetRef ref, User? user) async {
    final confirmacion = await _mostrarConfirmacion(
      context: ref.context,
      titulo: 'Quitar Administrador',
      mensaje: '¿Estás seguro de que deseas quitar el rol de administrador?',
    );
    if (confirmacion) {
      final resultado = await ref
          .read(userProvider.notifier)
          .quitarRolAdministrador(user?.uid);
          if (mounted) {
              _mostrarSnackbar(ref.context,
                resultado ? 'Rol de administrador eliminado' : 'Error al quitar rol');
          }
    }
  }

  Future<bool> _mostrarConfirmacion(
      {required BuildContext context,
      required String titulo,
      required String mensaje}) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _mostrarSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }
}
