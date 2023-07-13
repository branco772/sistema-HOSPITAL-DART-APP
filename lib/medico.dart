import 'package:sistemahospital/DatabaseHelper.dart';
import 'package:sistemahospital/consulta.dart';

class Medico {
  int? id;
  String nombre;
  DateTime fechaNacimiento;
  String genero;
  bool titular;
  String especialidad;
  List<String> dias;
  List<Consulta>? consultas;
  Medico({
    this.id,
    required this.nombre,
    required this.fechaNacimiento,
    required this.genero,
    required this.titular,
    required this.especialidad,
    required this.dias,
  });
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnMedicoId: id,
      DatabaseHelper.columnMedicoNombre: nombre,
      DatabaseHelper.columnMedicoFechaNacimiento:
          fechaNacimiento.toIso8601String(),
      DatabaseHelper.columnMedicoGenero: genero,
      DatabaseHelper.columnMedicoTitular: titular ? 1 : 0,
      DatabaseHelper.columnMedicoEspecialidad: especialidad,
      DatabaseHelper.columnMedicoDias: dias.join(','),
    };
  }

  factory Medico.fromMap(Map<String, dynamic> map) {
    return Medico(
      id: map[DatabaseHelper.columnMedicoId],
      nombre: map[DatabaseHelper.columnMedicoNombre],
      fechaNacimiento:
          DateTime.parse(map[DatabaseHelper.columnMedicoFechaNacimiento]),
      genero: map[DatabaseHelper.columnMedicoGenero],
      titular: map[DatabaseHelper.columnMedicoTitular] == 1 ? true : false,
      especialidad: map[DatabaseHelper.columnMedicoEspecialidad],
      dias: (map[DatabaseHelper.columnMedicoDias] as String).split(','),
    );
  }
}
