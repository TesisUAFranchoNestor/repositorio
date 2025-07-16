import 'package:mbarete_padel/domain/entities/cancha.dart';

class ReservaFija {
  
  final int idReservaFija;
  final String nombreReserva;
  final int horaInicio;
  final int horaFin;
  final String fechaInicio;
  final String fechaFin;
  final int dia;
  final int idCancha;
  final Cancha? cancha;

  ReservaFija({
    required this.idReservaFija, 
    required this.nombreReserva, 
    required this.horaInicio, 
    required this.horaFin, 
    required this.fechaInicio, 
    required this.fechaFin, 
    required this.dia, 
    required this.idCancha, 
    this.cancha
  });


  

  

}
