import 'package:mbarete_padel/domain/entities/entities.dart';

class HorarioMapper {
  static jsonToEntity(Map<String, dynamic> json) => Horario(
      idHorario: json['idHorario'] ?? 1,
      idLocal: json['idLocal'] ?? 1,
      dia: json['dia'] ?? 1,
      nombre: json['nombre'] ?? '',
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
      estado: json['estado'] ?? 1,
  );
}
