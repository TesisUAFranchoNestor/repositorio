import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mbarete_padel/domain/entities/reserva.dart';
import 'package:mbarete_padel/presentation/providers/providers.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static String get routeName => 'calendar';
  static String get routeLocation => '/$routeName';
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}


DateTime get _now => DateTime.now();

class CalendarScreenState extends ConsumerState<CalendarScreen> {
  late EventController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

     ref.read( reservaProvider.notifier ).calendarioReserva(1);
     

    _controller = CalendarControllerProvider.of(context).controller;
    _controller.removeWhere((event) => true); 

    
  }

  @override
  Widget build(BuildContext context) {

    final eventos = ref.watch(reservaProvider).calendario;
    final colors = Theme.of(context).colorScheme;
    if(eventos!=null){

      for(Reserva r in eventos){
        List<String> fecha = r.fecha.split('-');
        final event = CalendarEventData(
          date: DateTime(int.parse(fecha.first), int.parse(fecha[1]), int.parse(fecha[2])),
          title: r.idReserva.toString(),
          titleStyle: const TextStyle(fontSize: 15, color: Colors.white),
          startTime: DateTime(int.parse(fecha.first), int.parse(fecha[1]), int.parse(fecha[2]), r.horaInicio),
          endTime: DateTime(int.parse(fecha.first), int.parse(fecha[1]), int.parse(fecha[2]), r.horaFin),
          color: r.usuarioMod=='fijo' ? Colors.redAccent : colors.primary,
          description: r.usuarioMod=='fijo' ? 'fijo' : ''
        );
        _controller.add(event);          
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Reservas'),
        ),
        body: Padding(padding: const EdgeInsets.all(5),
        child: _CalendarVIiew())
      );
  }
}

class _CalendarVIiew extends ConsumerWidget {
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;

    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return WeekView(
        headerStyle:  HeaderStyle(
        decoration: BoxDecoration(color: colors.primary ),
        headerTextStyle: isDarkMode ? const TextStyle(color: Colors.black) : const TextStyle(color: Colors.white),  

      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      showLiveTimeLineInAllDays:
          true, // To display live time line in all pages in week view.
      width: 370, // width of week view.
      minDay: DateTime(1990),
      maxDay: DateTime(2050),
      initialDay: _now,
      heightPerMinute: 1, // height occupied by 1 minute time span.
      eventArranger:
          const SideEventArranger(), // To define how simultaneous events will be arranged.
      onEventTap: (events, date) {
        if(events.isNotEmpty){
          if(events.first.description!='fijo'){
            context.pushReplacement('/reservations-confirm/${events.first.title}');
          }else{
            context.pushReplacement('/reserva-fija/${events.first.title}');
            //ref.read(reservaFijaProvider.notifier).obtenerReservaFija(int.tryParse(events.first.title) ?? 0 );
          }
        }
      },
      onEventDoubleTap: (events, date) => {},
      onDateLongPress: (date) => {},
      startDay: WeekDays.monday, 
      startHour: 8,
      endHour: 23, 
      showVerticalLines: true, 
     
      keepScrollOffset:
          true, // To maintain scroll offset when the page changes
    );
  }
}