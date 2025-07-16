import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mbarete_padel/config/constants/enviroment.dart';
import 'package:mbarete_padel/config/theme/app_theme.dart';
import 'package:mbarete_padel/domain/entities/reserva.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final listaReservas = ref.watch(reservaProvider).listaReservas;

    final DateFormat df = DateFormat("yyyy-MM-dd");
    final DateFormat df2 = DateFormat("EEEE, dd MMM yyyy", "es");
    List<Reserva> historial = [];

    if (listaReservas != null) {
      for (Reserva r in listaReservas) {
        if (r.estado != 1) {
          historial.add(r);
        }
      }
    }
    return Scaffold(
        backgroundColor: colors.background,
        body: historial.isEmpty
            ? const Center(
                child: SingleChildScrollView(
                  child: NoTranscationMessage(
                    messageTitle: "Aún no completaste una reserva.",
                    messageDesc:
                        "Todavía no completaste reservaciones, reserva una cancha ahora",
                  ),
                ),
              )
            : ListView.builder(
                itemCount: historial.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      context.push(
                          '/reservations-confirm/${historial[index].idReserva}');
                    },
                    splashColor: colors.primary.withOpacity(0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          historial[index].cancha == null
                              ? Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/logo_dark.png')),
                                  ))
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              '${Enviroment.apiURL}/imagen/obtener/${historial[index].cancha!.idImagen}'))),
                                ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(capitalize(df2.format(df.parse(historial[index].fecha))),
                                  style: normalTextStyle),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${historial[index].horaInicio.toString().padLeft(2, '0')}:00 - ${historial[index].horaFin.toString().padLeft(2, '0')}:00 hs',
                                style: normalTextStyle,
                              ),
                            ],
                          ),
                          const Spacer(),
                          historial[index].estado == 2
                              ? Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red)),
                                  child: Text(
                                    "Cancelado",
                                    style: normalTextStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red),
                                  ))
                              : Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green)),
                                  child: Text(
                                    "Jugado",
                                    style: normalTextStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
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
