import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/transactions/no_transaction_message.dart';


class OrderScreen extends ConsumerWidget {

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {


    final listaReservas = ref.watch(reservaProvider).listaReservas;
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    List<Reserva> pendientes = [];
  
    if(listaReservas!=null){
      for(Reserva r in listaReservas){
        if(r.estado==1){
          pendientes.add(r);
        }
      }
    }
    
    final DateFormat df = DateFormat("yyyy-MM-dd");
    final DateFormat df2 = DateFormat("EEEE, dd MMM yyyy", "es");

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: colors.background,
        body: pendientes.isEmpty
            ? const Center(
                child: SingleChildScrollView(
                    child: NoTranscationMessage(
                messageTitle: "No tienes reservaciones",
                messageDesc:
                    "No tienes reservaciones pendientes. Reserva una cancha ahora",
              )))
            : ListView.builder(
                itemCount: pendientes.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                       context.push('/reservations-confirm/${pendientes[index].idReserva}');
                    },
                    splashColor: colors.primary.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          pendientes[index].cancha == null 
                          ? Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/logo_dark.png')
                                ),
                            )
                          )
                          : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: 
                                      
                                      NetworkImage(
                                      '${Enviroment.apiURL}/imagen/obtener/${pendientes[index].cancha!.idImagen}')
                                        )
                                      ),
                            ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(capitalize(df2.format(df.parse(pendientes[index].fecha))),
                                  style: normalTextStyle),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${pendientes[index].horaInicio.toString().padLeft(2, '0')}:00 - ${pendientes[index].horaFin.toString().padLeft(2, '0')}:00 hs',
                                style: normalTextStyle,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.yellow.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.yellow)),
                              child: Text(
                                "Pendiente",
                                style: normalTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.yellow : Colors.black54),
                              ))
                        ],
                      ),
                    ),
                  );
                }));
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
