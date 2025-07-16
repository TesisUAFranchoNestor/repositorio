import 'package:mbarete_padel/domain/entities/cancha.dart';

class Reserva {
  
  final int idReserva;
  final String fecha;
  final int horaInicio;
  final int horaFin;
  final int estado;
  final int dia;
  final String usuarioMod;
  final Cancha? cancha;

  Reserva({
    required this.idReserva, 
    required this.fecha, 
    required this.horaInicio, 
    required this.horaFin, 
    required this.estado, 
    required this.dia, 
    this.usuarioMod = '',
    this.cancha
  });


  

  

}
