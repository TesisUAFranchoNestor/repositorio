import 'package:mbarete_padel/domain/entities/entities.dart';
import 'package:mbarete_padel/infraestructure/mappers/cancha_mappers.dart';

class ReservaMapper {
  static jsonToEntity(Map<String, dynamic> json) => Reserva(
    idReserva: json['idReserva'], 
    fecha: json['fecha'], 
    horaInicio: json['horaInicio'], 
    horaFin: json['horaFin'], 
    estado: json['estado'], 
    dia: json['dia'], 
    usuarioMod: json['usuarioMod'], 
    cancha: json['cancha'] !=null ? CanchaMapper.jsonToEntity(json['cancha']) : null
  );
}
