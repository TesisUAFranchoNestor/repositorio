
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/presentation/providers/reservas_fijas/reserva_fija_provider.dart';
import 'package:intl/intl.dart';

class ReservaFijaScreen extends ConsumerStatefulWidget{
  static String get routeName => 'reserva-fija';
  static String get routeLocation => '/$routeName';
  final String id;


  const ReservaFijaScreen({super.key, required this.id});

  @override
  ReservaFijaScreenState createState() => ReservaFijaScreenState();
}

class ReservaFijaScreenState extends ConsumerState<ReservaFijaScreen> {
 final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _fechaFinController = TextEditingController();

  // Mapa para asociar los días de la semana con números (lunes = 1, domingo = 7)
  final Map<String, int> _diasSemanaMap = {
    'Lunes': 1,
    'Martes': 2,
    'Miércoles': 3,
    'Jueves': 4,
    'Viernes': 5,
    'Sábado': 6,
    'Domingo': 7,
  };

  // Valor seleccionado
  String? _diaSeleccionado;

  // Variable para almacenar el número del día
  int? _numeroDiaSeleccionado;



  @override
  void initState() {
    super.initState();
    if(widget.id!='-99'){
      ref.read( reservaFijaProvider.notifier ).obtenerReservaFija(int.tryParse(widget.id) ?? -99);
    }else{
      _nombreController.text = '';
      _horaInicioController.text = '';
      _horaFinController.text = '';
      _fechaInicioController.text = '';
      _fechaFinController.text = '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _horaInicioController.dispose();
    _horaFinController.dispose();
    _fechaInicioController.dispose();
    _fechaFinController.dispose();
    super.dispose();
  }


  Future<void> _seleccionarFecha(TextEditingController controller, String tipo) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      String fomattedDate = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);
      controller.text  = fomattedDate;

      if(tipo=='inicio'){
        ref.read(reservaFijaProvider.notifier).onFechaInicioChange(fomattedDate);
      }else{
        ref.read(reservaFijaProvider.notifier).onFechaFinChange(fomattedDate);
      }

    }
  }

  showSnackbar(BuildContext context, String message, String tipo) {
    final textTheme  = Theme.of(context).textTheme;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        message, 
        style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        backgroundColor: tipo=='error' ? Colors.red.shade600 : Colors.green.shade600, )
    );
  }

  void _guardarReserva() async {
    if (_formKey.currentState!.validate()) {
        
      bool resultado = await ref.read(reservaFijaProvider.notifier).guardar( widget.id );

      if (mounted) { // Verifica si el widget sigue montado
        if (resultado) {
          context.pushReplacement('/calendar');
          showSnackbar(context, 'Reserva ${widget.id == '-99' ? 'creada' : 'modificada'}','success');
        } else {
          showSnackbar(context, 'Error al guardar la reserva','error');
        }
      }
    }
  }

  void _eliminarReserva() async {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: const Text('¿Deseas eliminar esta reserva?'),
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
        bool resultado = await ref.read(reservaFijaProvider.notifier).eliminar(widget.id);

        if (mounted) { // Verifica si el widget sigue montado
          if (resultado) {
            context.push('/calendar');
            showSnackbar(context, 'Reserva removida', 'success');
          } else {
            showSnackbar(context, 'Error al eliminar reserva', 'error');
          }
        }
      }
    }


  @override
  Widget build(BuildContext context) {
    final reserva = ref.watch(reservaFijaProvider).reservaFija;

  if (reserva != null && widget.id!='-99') {
       _nombreController.text = reserva.nombreReserva;
      _horaInicioController.text = reserva.horaInicio.toString();
      _horaFinController.text = reserva.horaFin.toString();
      _fechaInicioController.text = reserva.fechaInicio;
      _fechaFinController.text = reserva.fechaFin;
      _diaSeleccionado = _diasSemanaMap.entries
        .firstWhere((element) => element.value == reserva.dia)
        .key; // Asignar el valor del día de la semana
      _numeroDiaSeleccionado = reserva.dia;
    }



    return Scaffold(
      appBar: AppBar(title: const Text('Reserva Fija'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la reserva'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onChanged: (value) {
                  ref.read(reservaFijaProvider.notifier).onNombreChange(value);
              },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Hora de inicio'),
              value: int.tryParse(_horaInicioController.text),
              items: List.generate(24, (index) => index + 1)
                  .map((hora) => DropdownMenuItem<int>(
                        value: hora,
                        child: Text(hora.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(reservaFijaProvider.notifier).onHoraInicioChange(value);
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor selecciona una hora de inicio';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Hora de Fin'),
              value: int.tryParse(_horaFinController.text),
              items: List.generate(24, (index) => index + 1)
                  .map((hora) => DropdownMenuItem<int>(
                        value: hora,
                        child: Text(hora.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(reservaFijaProvider.notifier).onHoraFinChange(value);
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor selecciona una hora de fin';
                }
                return null;
              },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaInicioController,
                decoration: const InputDecoration(labelText: 'Fecha de inicio'),
                readOnly: true,
                onTap: () => _seleccionarFecha(_fechaInicioController,'inicio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una fecha de inicio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaFinController,
                decoration: const InputDecoration(labelText: 'Fecha de fin'),
                readOnly: true,
                onTap: () => _seleccionarFecha(_fechaFinController,'fin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una fecha de fin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
             DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Día de la semana'),
              value: _diaSeleccionado,
              items: _diasSemanaMap.keys.map((String dia) {
                return DropdownMenuItem<String>(
                  value: dia,
                  child: Text(dia),
                );
              }).toList(),
              onChanged: (newValue) {
                _diaSeleccionado = newValue;
                _numeroDiaSeleccionado = _diasSemanaMap[newValue];
                ref.read(reservaFijaProvider.notifier).onDiaChange(_numeroDiaSeleccionado);
                
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecciona un día de la semana';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _guardarReserva,
              child: (widget.id=='-99') ? const Text('Guardar Reserva') : const Text('Modificar Reserva'),
            ),
            const SizedBox(height: 32),
              (widget.id!='-99') 
              ?  ElevatedButton(
                  onPressed: _eliminarReserva,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,             // Fondo rojo
                    foregroundColor: Colors.white,           // Texto blanco
                    side: const BorderSide(color: Colors.red), // Borde rojo
                  ),
                  child: const Text('Eliminar Reserva') ,
                ) 
              : const SizedBox()

            ],
          ),
        ),
      ),
    );
  }
}