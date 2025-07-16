import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/cancha_mappers.dart';

class ReservaFijaMapper {
  static jsonToEntity(Map<String, dynamic> json) => ReservaFija(
    idReservaFija: json['idReservaFija'], 
    nombreReserva: json['nombreReserva'], 
    horaInicio: json['horaInicio'], 
    horaFin: json['horaFin'], 
    fechaInicio: json['fechaInicio'], 
    fechaFin: json['fechaFin'], 
    dia: json['dia'], 
    idCancha: json['idCancha'], 
    cancha: json['cancha'] !=null ? CanchaMapper.jsonToEntity(json['cancha']) : null
  );
}
