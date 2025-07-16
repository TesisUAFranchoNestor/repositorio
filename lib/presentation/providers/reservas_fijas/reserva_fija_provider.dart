import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/domain/repositories/reserva_fija_repository.dart';
import 'package:mbarete_padel/presentation/providers/reservas_fijas/reserva_fija_repository_provider.dart';

final reservaFijaProvider  = StateNotifierProvider<ReservaFijaNotifier,ReservaFijaState>((ref) {
  final reservaFijaRepo = ref.watch( reservaFijaRepositoryProvider );

  return ReservaFijaNotifier(reservaRepository: reservaFijaRepo);

});

class ReservaFijaNotifier extends StateNotifier<ReservaFijaState> {

  final ReservaFijaRepository reservaRepository;

  ReservaFijaNotifier({
    required this.reservaRepository
  }): super(ReservaFijaState());

  Future<bool> crearReservaFija() async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    final reservaLike = {
      'nombre': state.nombre, 
      'horaInicio': state.horaInicio,
      'horaFin': state.horaFin,
      'fechaInicio': state.fechaInicio,
      'fechaFin': state.fechaFin,
      'idCancha': state.idCancha,
      'dia': state.dia
    };

    final ReservaFija? reserva = await reservaRepository.crearReservaFija(reservaLike, accessToken);
    
    return reserva==null ? false : true;
  }

  Future<ReservaFija?> obtenerReservaFija(int idReservaFija) async {
    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    final ReservaFija? reservaFija = await reservaRepository.obtenerReservaFija(idReservaFija, accessToken);
    state = state.copyWith(
       reservaFija: reservaFija,
       nombre: reservaFija?.nombreReserva,
       fechaInicio: reservaFija?.fechaInicio,
       fechaFin: reservaFija?.fechaFin,
       horaFin: reservaFija?.horaFin,
       horaInicio: reservaFija?.horaInicio,
       dia: reservaFija?.dia,
       idCancha: reservaFija?.idCancha,
       idReservaFija: reservaFija?.idReservaFija,
    ); 
    return reservaFija;
  }




  onNombreChange( String value ){
    state = state.copyWith(
      nombre: value
    );
  }

  onHoraInicioChange( int value ){
    state = state.copyWith(
      horaInicio: value
    );
  }

  onHoraFinChange( int value ){
    state = state.copyWith(
      horaFin: value
    );
  }

  onFechaInicioChange(String value ){
    state = state.copyWith(
      fechaInicio: value
    );
  }

  onFechaFinChange(String value ){
    state = state.copyWith(
      fechaFin: value
    );
  }

  onDiaChange(int? value ){
    state = state.copyWith(
      dia: value
    );
  }

  onIdReservaChange(int? value ){
    state = state.copyWith(
      idReservaFija: value
    );
  }

  Future<bool> guardar(String? id) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    
    state = state.copyWith(
      idCancha: 1
    );

    final reservaLike = {
      'nombreReserva': state.nombre, 
      'horaInicio': state.horaInicio,
      'horaFin': state.horaFin,
      'fechaInicio': state.fechaInicio,
      'fechaFin': state.fechaFin,
      'idCancha': state.idCancha,
      'dia': state.dia
    };

    // Agregamos idReservaFija solo si no es null
    if (state.idReservaFija != null && id!='-99') {
      reservaLike['idReservaFija'] = state.idReservaFija;
    }

    //print(reservaLike);


    final ReservaFija? reserva = await reservaRepository.crearReservaFija(reservaLike, accessToken);

    state = state.copyWith(
       reservaFija: null,
       nombre: null,
       fechaInicio: null,
       fechaFin: null,
       horaFin: null,
       horaInicio: null,
       dia: null,
       idCancha: null,
       idReservaFija: null,
    );

    return reserva == null ? false : true;
    //return false;

  }

  Future<bool> eliminar(String? id) async {

    final accessToken =  await FirebaseAuth.instance.currentUser!.getIdToken() ?? '';
    

    final ReservaFija? reserva = await reservaRepository.eliminarReserva(state.idReservaFija, accessToken);

    state = state.copyWith(
       reservaFija: null,
       nombre: null,
       fechaInicio: null,
       fechaFin: null,
       horaFin: null,
       horaInicio: null,
       dia: null,
       idCancha: null,
       idReservaFija: null,
    );

    return reserva == null ? false : true;
    //return false;

  }




}


class ReservaFijaState  {

  int? idReservaFija;
  String? nombre;
  int? horaInicio;
  int? horaFin;
  String? fechaInicio;
  String? fechaFin;
  int? dia;
  int? idCancha;
  Cancha? cancha;
  ReservaFija? reservaFija;

  ReservaFijaState({
    this.idReservaFija,
    this.nombre,
    this.horaInicio,
    this.horaFin,
    this.fechaInicio,
    this.fechaFin,
    this.dia,
    this.idCancha,
    this.cancha,
    this.reservaFija,
  });
    
  ReservaFijaState copyWith({
    int? idReservaFija,
    String? nombre,
    int? horaInicio,
    int? horaFin,
    String? fechaInicio,
    String? fechaFin,
    int? dia,
    int? idCancha,
    Cancha? cancha,
    ReservaFija? reservaFija,
  }) => ReservaFijaState(
    idReservaFija: idReservaFija ?? this.idReservaFija,
    nombre: nombre ?? this.nombre,
    horaInicio: horaInicio ?? this.horaInicio,
    horaFin: horaFin ?? this.horaFin,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin ?? this.fechaFin,
    dia: dia ?? this.dia,
    cancha: cancha ?? this.cancha,
    idCancha: idCancha ?? this.idCancha,
    reservaFija: reservaFija ?? this.reservaFija,
  );

}