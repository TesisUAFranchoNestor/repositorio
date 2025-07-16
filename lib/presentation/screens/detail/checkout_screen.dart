import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:select_field/select_field.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String id;
  static String get routeName => 'confirm';
  static String get routeLocation => '/$routeName';
  const CheckoutScreen({super.key, required this.id});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  DateTime _dateTime = DateTime.now();
  final dateFormat = DateFormat("EEEE, dd MMM yyyy", "es");
  var currentTime = "00.00";

  @override
  void initState() {
    super.initState();
      ref.read(horarioProvider.notifier).listarHorariosReserva();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final canchasDisponibles = ref.watch(canchaProvider);

    final login = ref.watch(loginProvider);

    late Cancha canchaDatos;
    for (Cancha cancha in canchasDisponibles.canchas) {
      if (cancha.idCancha.toString() == widget.id) {
        canchaDatos = cancha;
      }
    }

    final horario = ref.watch(horarioProvider);

    if(horario.fecha!=null) {
      _dateTime = DateTime.parse(horario.fecha ?? '');
    }


    double total = canchaDatos.precio * horario.horas; 
    NumberFormat numberFormat = NumberFormat.currency(locale: 'eu', decimalDigits: 0, symbol: 'Gs.');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Confirmar"),
            centerTitle: true,
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, bottom: 24, top: 8),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text(
                  //   "Cancha",
                  //   style: subTitleTextStyle,
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: colors.primary.withOpacity(0.5), width: 2),
                  //       color: colors.primary.withOpacity(0.2),
                  //       borderRadius: BorderRadius.circular(16)),
                  //   child: Row(
                  //     children: [
                  //       const Icon(Icons.stadium),
                  //       const SizedBox(
                  //         width: 8,
                  //       ),
                  //       Text(field.name),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  Text(
                    "Selecciona la fecha",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: colors.primary.withOpacity(0.5), width: 2),
                          color: colors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(dateFormat.format(_dateTime).toString()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Selecciona la duracion",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const StyledSelectField(),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Selecciona el horario",
                    style: subTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const StyledSelectFieldHorario(),
                  const SizedBox(
                    height: 8,
                  ),
                  //...availableBookTime.map(buildSingleCheckBox).toList(),
                ],
              ),
            ])),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: colors.background, boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.7),
            offset: const Offset(0, 0),
            blurRadius: 10,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total:",
                  style: descTextStyle,
                ),
                horario.isValid 
                ? Text(
                    (numberFormat.format(total)),
                    style: priceTextStyle,
                  )
                : Text(
                    "0 Gs.",
                    style: priceTextStyle,
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  onPressed: !horario.isValid 
                      ? null
                      : () {

                          ref.read( reservaProvider.notifier ).copiarValores(
                              fecha: horario.fecha,
                              horaInicio: horario.horaInicio,
                              horaFin: horario.horaFin,
                              idLocal: canchaDatos.local.idLocal,
                              idCancha: canchaDatos.idCancha,
                              idUsuario: login.idUsuario
                          );                        

                          ref.watch( reservaProvider.notifier ).reservar().then((success) {
                            if (success) {
                              ref.watch(horarioProvider.notifier).clearHorario();
                              int? idReserva=ref.read(reservaProvider.notifier).obtenerIdReserva();
                              context.pushReplacement('/success/$idReserva');
                            } else {
                              // Manejar el caso de reserva fallida, por ejemplo, mostrar un mensaje de error.
                              _showSnackBar(context,'No se pudo realizar la reserva revise los datos');
                            }
                          }).catchError((error) {
                            // Manejar errores si ocurren durante la reserva.
                          });
                          

                        },
                  child: const Text(
                    "Confirmar Reserva",
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();

    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      margin: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade600, 
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectDate() async {



    await showDatePicker(
            context: context,
            locale: const Locale("es"),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 15))
        .then((value) {
          ref.read(horarioProvider.notifier).changeDate(
              value.toString().split(' ')[0]);
          
          //ref.read(horarioProvider.notifier).listarHorariosReserva();

      /*setState(() {
        _dateTime = value!;
      }); */
    });
  }

  
}

const durationOptions = <String>[
  '1 hora',
  '2 horas',
  '3 horas',
  '4 horas',
];

class StyledSelectField extends ConsumerWidget {
  const StyledSelectField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final options = durationOptions
        .map((duracion) => Option(label: duracion, value: duracion))
        .toList();

    return SelectField<String>(
      options: options,
      initialOption: Option<String>(
        label: durationOptions[1],
        value: durationOptions[1],
      ),
      menuPosition: MenuPosition.below,
      onTextChanged: (value) => debugPrint(value),
      onOptionSelected: (option) {

      ref.read(horarioProvider.notifier).changeDuration(
            int.parse(option.value.split(' ')[0]));
      //ref.read(horarioProvider.notifier).listarHorariosReserva();

      },
      inputStyle: const TextStyle(),
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: colors.primary, style: BorderStyle.solid)),
        fillColor: colors.primary.withOpacity(0.2),
        prefixIcon: const Icon(Icons.timer),
      ),
      menuDecoration: MenuDecoration(
        margin: const EdgeInsets.only(top: 8),
        height: 250,
        alignment: MenuAlignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              color: Colors.brown[300]!,
              blurRadius: 3,
            ),
          ],
        ),
        animationDuration: const Duration(milliseconds: 100),
        buttonStyle: TextButton.styleFrom(
          fixedSize: const Size(double.infinity, 60),
          backgroundColor: Colors.green[100],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        separatorBuilder: (context, index) => Container(
          height: 1,
          width: double.infinity,
          color: Colors.green,
        ),
      ),
    );
  }
}

class StyledSelectFieldHorario extends ConsumerWidget {
  const StyledSelectFieldHorario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final horarios = ref.watch(horarioProvider).horariosReserva;
    final horariosPrv = ref.watch(horarioProvider);
    String selectedValue='';
    if(horariosPrv.horaInicio!=-1){
      selectedValue='${horariosPrv.horaInicio}-${horariosPrv.horaFin}';
    }
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (horarios != null) {
      final options = horarios
          .map((horario) {

              if(selectedValue==''){
                selectedValue = horario.estado == 0 ? '' : '${horario.horaInicio}-${horario.horaFin}';
              }

              return  DropdownMenuItem<String>(
                value: '${horario.horaInicio}-${horario.horaFin}',
                enabled: horario.estado == 1 ? true : false,
              
                child: Text('${horario.horaInicio}:00 hs - ${horario.horaFin}:00 hs', style: TextStyle(
                color: horario.estado == 0 ? Colors.grey : isDarkMode ? Colors.white : Colors.black87, 
                )));
          })
          .toList();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border:
                Border.all(color: colors.primary.withOpacity(0.5), width: 2),
            color: colors.primary.withOpacity(0.2),
            
            borderRadius: BorderRadius.circular(16)),
            
        child: options.isNotEmpty && selectedValue!=''
            ? DropdownButton<String>(
                value: selectedValue,
                dropdownColor: isDarkMode ? Colors.black87 : Colors.white,
                onChanged: (String? newValue) {
                  if(newValue!=null){
                    ref.read(horarioProvider.notifier).changeHour(
                      int.parse(newValue.split('-')[0]),
                      int.parse(newValue.split('-')[1]),
                    );
                  }
                  
                },
                items: options,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: const SizedBox(),
                
              )
            : const SizedBox(height: 42,child: Center(child: Text('No hay horarios disponibles')),)
      );
    } else {
      return const SizedBox(height: 42,child: Center(child: Text('No hay horarios disponibles')),);
    }
  }
}
