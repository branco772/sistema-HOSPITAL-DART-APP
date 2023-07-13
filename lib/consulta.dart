class Consulta {
  int? id;
  DateTime fechaConsulta;
  String horaInicio;
  int numeroConsultorio;
  int medicoId;
  int pacienteId;
  String observaciones;

  Consulta({
    this.id,
    required this.fechaConsulta,
    required this.horaInicio,
    required this.numeroConsultorio,
    required this.medicoId,
    required this.pacienteId,
    required this.observaciones,
  });

  // Método para convertir un objeto Consulta a un Map (utilizado para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_consulta': fechaConsulta.toIso8601String(),
      'hora_inicio': horaInicio,
      'numero_consultorio': numeroConsultorio,
      'medico_id': medicoId,
      'paciente_id': pacienteId,
      'observaciones': observaciones,
    };
  }

  // Método para crear un objeto Consulta a partir de un Map (utilizado para leer desde la base de datos)
  static Consulta fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'],
      fechaConsulta: DateTime.parse(map['fecha_consulta']),
      horaInicio: map['hora_inicio'],
      numeroConsultorio: map['numero_consultorio'],
      medicoId: map['medico_id'],
      pacienteId: map['paciente_id'],
      observaciones: map['observaciones'],
    );
  }
}
