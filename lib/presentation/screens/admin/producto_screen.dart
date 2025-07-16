import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/presentation/providers/productos/producto_local_provider.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';

class ProductScreen extends ConsumerStatefulWidget {
  static String get routeName => 'product';
  static String get routeLocation => '/$routeName';
  final String id;

  const ProductScreen({super.key, required this.id});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<ProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();


  @override
  void initState() {
    super.initState();
    ref.read(productoLocalProvider.notifier).obtenerProductoLocal(int.tryParse(widget.id));
  }

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {

      
      if (_selectedImage == null && widget.id == '-99') {
        if (mounted) {
          _showSnackbar(context, 'Por favor selecciona una imagen', 'error');
        }
        return;
      }

      String? idImagen;

      // Solo subir imagen si se seleccionó una nueva
      if (_selectedImage != null) {
        idImagen = await ref.read(imagenProvider.notifier).subirImagen(_selectedImage);
        if (idImagen == null) {
          if (mounted) {
            _showSnackbar(context, 'No se pudo subir la imagen. La imagen debe pesar menos de 10MB', 'error');
          }
          return;
        }

        final idImagenInt = int.tryParse(idImagen);
        ref.read(productoLocalProvider.notifier).onIdImagenChange(idImagenInt);
      }



      ref.read(productoLocalProvider.notifier).onPrecioChange(double.tryParse(_precioController.text));
      ref.read(productoLocalProvider.notifier).onStockChange(int.tryParse(_stockController.text));


      bool resultado = await ref.read(productoLocalProvider.notifier).crearProducto();

      if(resultado){
        resultado = await ref.read(productoLocalProvider.notifier).crearProductoLocal(); 
      }

      if (mounted) {
        _showSnackbar(
          context,
          resultado ? 'Producto agregado exitosamente' : 'No se pudo agregar producto',
          resultado ? 'success' : 'error',
        );
        if(resultado){
          context.pop(true);
        }
        
      }
    }
  }

  void _showSnackbar(BuildContext context, String message, String tipo) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: tipo == 'error' ? Colors.red.shade600 : Colors.green.shade600,
      ),
    );
  }

    void _eliminarProducto() async {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: const Text('¿Deseas eliminar este producto?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cerrar el diálogo sin eliminar
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirmar eliminación
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      if (confirmacion == true) {
        // Solo si el usuario confirmó, realiza la eliminación
        bool resultado = await ref.read(productoLocalProvider.notifier).eliminarProductoLocal();

        if (mounted) { // Verifica si el widget sigue montado
          if (resultado) {
            context.pop(true);
            _showSnackbar(context, 'Producto eliminado', 'success');
          } else {
            _showSnackbar(context, 'Error al eliminar producto', 'error');
          }
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    final producto = ref.watch(productoLocalProvider);


    if (producto.producto != null && widget.id!='-99') {
       _titleController.text = producto.producto?.titulo ?? '';
      _brandController.text = producto.producto?.marca ?? '';
      _descriptionController.text = producto.producto?.descripcion ?? '';
      _stockController.text = producto.stock?.toString() ?? '0';
      _precioController.text = producto.precio?.toString() ?? '0.0';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id == '-99' ? 'Agregar Producto' : 'Editar Producto'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
                onChanged: ref.read(productoLocalProvider.notifier).onTituloChange
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la marca';
                  }
                  return null;
                },
                onChanged: ref.read(productoLocalProvider.notifier).onMarcaChange
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
                onChanged: ref.read(productoLocalProvider.notifier).onDescripcionChange
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  return null;
                },
                
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.file(_selectedImage!, height: 150),
                ),
              if(_selectedImage == null && producto.producto?.idImagen!=null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.network('${Enviroment.apiURL}/imagen/obtener/${producto.producto!.idImagen}', height: 150),
                ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                  child: Text(widget.id == '-99' ? 'Crear Producto' : 'Actualizar Producto'),
              ),
              if(widget.id!='-99')
              ElevatedButton(
                onPressed: _eliminarProducto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                  child: const Text('Eliminar Producto' ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
