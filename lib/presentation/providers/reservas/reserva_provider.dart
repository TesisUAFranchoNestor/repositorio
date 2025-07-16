import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/reserva_repository.dart';
import 'package:mbarete_padel/presentation/providers/reservas/reserva_repository_provider.dart';

final reservaProvider  = StateNotifierProvider<ReservaNotifier,ReservaState>((ref) {
  final reservaRepo = ref.watch( reservaRepositoryProvider );

  return ReservaNotifier(reservaRepository: reservaRepo);

});

class ReservaNotifier extends StateNotifier<ReservaState> {

  final ReservaRepository reservaRepository;

  ReservaNotifier({
    required this.reservaRepository
  }): super(ReservaState());

  Future<bool> reservar() async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    final reservaLike = {
      'fecha': state.fecha, 
      'horaInicio': state.horaInicio,
      'horaFin': state.horaFin,
      'idLocal': state.idLocal,
      'idCancha': state.idCancha,
      'estado': 1,
      'idUsuario': state.idUsuario
    };

    final Reserva? reserva = await reservaRepository.reservar(reservaLike, accessToken);
    if(reserva!=null){
      state = state.copyWith(idReserva: reserva.idReserva);
    }
    return reserva==null ? false : true;
  }

  int? obtenerIdReserva(){

    return state.idReserva;
  }


  Future<Reserva?> getReservaById(int idReserva) async {
    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final Reserva? reserva = await reservaRepository.reservaById(idReserva, accessToken);
    if(reserva!=null){
      state = state.copyWith(
        reserva: reserva,
        idReserva: reserva.idReserva
      );
    }
    return reserva;
  }

  Future<List<Reserva>?> listarReservasPorUsuario( int idUsuario ) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<Reserva>? lista = await reservaRepository.reservasPorUsuario(idUsuario, accessToken);
    if(lista!=null){
      state = state.copyWith(
        listaReservas: lista
      );
    }
    return lista;

  }

  Future<List<Reserva>?> calendarioReserva( int idCancha) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final List<Reserva>? lista = await reservaRepository.calendarioAdmin(idCancha, accessToken);
    if(lista!=null){
      state = state.copyWith(
        calendario: lista
      );
    }
    return lista;

  }

  void copiarValores({String? fecha, int? horaInicio, int? horaFin, int? idLocal, int? idCancha, int? idUsuario}){

    state = state.copyWith(
      fecha: fecha,
      horaInicio: horaInicio,
      horaFin: horaFin,
      idLocal: idLocal,
      idCancha: idCancha,
      idUsuario: idUsuario
    );


  }

  Future<bool> cancelarReserva(int? idUsuario) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';

    final Reserva? reserva = await reservaRepository.cancelar(state.idReserva ?? 0, accessToken);
    if(reserva!=null){
      state = state.copyWith(idReserva: reserva.idReserva);
      listarReservasPorUsuario(idUsuario ?? 0);
    }
    return reserva==null ? false : true;
  }
}

class ReservaState  {

  int? idReserva;
  String? fecha;
  int? horaInicio;
  int? horaFin;
  int? estado;
  int? dia;
  int? idLocal;
  int? idCancha;
  Cancha? cancha;
  int? idUsuario;
  Reserva? reserva;
  List<Reserva>? listaReservas;
  List<Reserva>? calendario;

  ReservaState({
    this.idReserva,
    this.fecha,
    this.horaInicio,
    this.horaFin,
    this.estado,
    this.dia,
    this.idLocal,
    this.idCancha,
    this.cancha,
    this.idUsuario,
    this.listaReservas,
    this.reserva,
    this.calendario
  });
    
  ReservaState copyWith({
    int? idReserva,
    String? fecha,
    int? horaInicio,
    int? horaFin,
    int? estado,
    int? dia,
    int? idLocal,
    int? idCancha,
    Cancha? cancha,
    int? idUsuario,
    List<Reserva>? listaReservas,
    Reserva? reserva,
    List<Reserva>? calendario
  }) => ReservaState(
    idReserva: idReserva ?? this.idReserva,
    fecha: fecha ?? this.fecha,
    horaInicio: horaInicio ?? this.horaInicio,
    horaFin: horaFin ?? this.horaFin,
    estado: estado ?? this.estado,
    dia: dia ?? this.dia,
    cancha: cancha ?? this.cancha,
    idUsuario: idUsuario ?? this.idUsuario,
    idLocal: idLocal ?? this.idLocal,
    idCancha: idCancha ?? this.idCancha,
    listaReservas: listaReservas ?? this.listaReservas,
    reserva: reserva ?? this.reserva,
    calendario: calendario ?? this.calendario
  );

}