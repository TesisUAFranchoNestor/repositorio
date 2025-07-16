import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/horario_repository.dart';
import 'package:mbarete_padel/presentation/providers/horarios/horarios_repository_provider.dart';

final horarioProvider  = StateNotifierProvider<HorarioNotifier,HorarioState>((ref) {
  final horarioRepo = ref.watch( horariosRepositoryProvider );

  return HorarioNotifier(horarioRepository: horarioRepo);

});

class HorarioNotifier extends StateNotifier<HorarioState> {

  final HorarioRepository horarioRepository;

  HorarioNotifier({
    required this.horarioRepository
  }): super(HorarioState(horarios: []));

  Future<List<Horario>> listarHorarios(int idLocal) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<Horario> horarios = await horarioRepository.listarHorario(idLocal, accessToken);
    state = state.copyWith(horarios: horarios);
    return horarios;
  }

  Future<List<Horario>> listarHorariosReserva() async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    DateTime dateTime = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd","es");
    
    final horarioLike = {
           'idCancha': state.idCancha ?? 1, 
           'idLocal':  state.idLocal ?? 1, 
           'horas': state.horas,
           'fecha': state.fecha ?? dateFormat.format(dateTime) 
    };  
    

    final List<Horario> horarios = await horarioRepository.listarHorariosReserva(horarioLike, accessToken);
    state = state.copyWith(horarios: state.horarios, horariosReserva: horarios, fecha: state.fecha ?? dateFormat.format(dateTime) );
    return horarios;
  }

  void changeDuration(int horas) async{
    state = state.copyWith(
      horarios: state.horarios, 
      horas: horas,
      horaInicio: -1,
      horaFin: -1,
      isValid: false
    );
    await listarHorariosReserva();
  }

  void clearHorario() async{
    DateTime dateTime = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd","es");

    state = state.copyWith(
      horarios: state.horarios, 
      fecha: dateFormat.format(dateTime),
      horas: 2,
      horaInicio: -1,
      horaFin: -1,
      isValid: false
    );
    //await listarHorariosReserva();
  }

  void changeDate(String fecha) async{
    state = state.copyWith(
      horarios: state.horarios, 
      fecha: fecha, 
      horaInicio: -1,
      horaFin: -1,
      isValid: false
    );
    await listarHorariosReserva();
  }

  void changeHour(int horaInicio, int horaFin) async{
    state = state.copyWith(
      horarios: state.horarios, 
      horaInicio: horaInicio,
      horaFin: horaFin,
      isValid: true
    );
  }


}


class HorarioState  {

  final List<Horario> horarios;
  int? idLocal;
  int? idCancha;
  String? fecha;
  int horas;
  List<Horario>? horariosReserva;
  int horaInicio;
  int horaFin;
  bool isValid;

  HorarioState({
    required this.horarios,
    this.idLocal,
    this.idCancha,
    this.fecha,
    this.horas = 2,
    this.horariosReserva,
    this.horaInicio = -1,
    this.horaFin = -1,
    this.isValid = false
  });
    
  HorarioState copyWith({
    required List<Horario> horarios,
    int? idLocal,
    int? idCancha,
    String? fecha,
    int? horas,
    List<Horario>? horariosReserva,
    int? horaInicio,
    int? horaFin,
    bool? isValid,
  }) => HorarioState(
    horarios: horarios,
    idLocal: idLocal ?? this.idLocal,
    idCancha: idCancha ?? this.idCancha,
    fecha: fecha ?? this.fecha,
    horas: horas ?? this.horas,
    horariosReserva: horariosReserva ?? this.horariosReserva,
    horaInicio: horaInicio ?? this.horaInicio,
    horaFin: horaFin ?? this.horaFin,
    isValid: isValid ?? this.isValid,
  );

}