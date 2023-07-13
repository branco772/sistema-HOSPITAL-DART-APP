import 'package:sistemahospital/consulta.dart';

class Paciente {
  int? matricula;
  String nombre;
  DateTime fechaNacimiento;
  String genero;
  bool titular;
  List<Consulta>? consultas;
  Paciente({
    this.matricula,
    required this.nombre,
    required this.fechaNacimiento,
    required this.genero,
    required this.titular,
  });

  Map<String, dynamic> toMap() {
    return {
      'matricula': matricula,
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'genero': genero,
      'titular': titular ? 1 : 0,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      matricula: map['matricula'],
      nombre: map['nombre'],
      fechaNacimiento: DateTime.parse(map['fechaNacimiento']),
      genero: map['genero'],
      titular: map['titular'] == 1,
    );
  }
}
