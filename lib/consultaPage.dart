import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistemahospital/consulta.dart';
import 'package:sistemahospital/DatabaseHelper.dart';
import 'package:sistemahospital/medico.dart';
import 'package:sistemahospital/paciente.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({Key? key}) : super(key: key);
  @override
  _ConsultaPageState createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper.instance;
  final _dateFormat = DateFormat('dd/MM/yyyy');
  List<Consulta> _consultas = [];
  DateTime? fechaConsulta;
  String _fecha = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();

  List<Medico> listaMedicos = [];
  Medico? medicoSeleccionado;
  List<Paciente> listaPacientes = [];
  Paciente? pacienteSeleccionado;
  @override
  void initState() {
    super.initState();
    _loadConsultas();
    _loadMedicos();
    _loadPacientes();
  }

  Future<void> _loadConsultas() async {
    final consultas = await _databaseHelper.getAllConsulta();
    setState(() {
      _consultas = consultas;
    });
  }

  Future<void> _loadMedicos() async {
    final medicos = await _databaseHelper.getAllMedicos();
    setState(() {
      listaMedicos = medicos;
    });
  }

  Future<void> _loadPacientes() async {
    final pacientes = await _databaseHelper.getAllPacientes();
    setState(() {
      listaPacientes = pacientes;
    });
  }

  Future<void> _saveConsulta(Consulta consulta) async {
    await _databaseHelper.insertConsulta(consulta);
    _loadConsultas();
  }

  void _showEditDialog(Consulta consulta) {
    String observaciones = consulta.observaciones;
    DateTime? fechaConsulta = consulta.fechaConsulta;
    int numeroConsultorio = consulta.numeroConsultorio;
    String horaInicio = consulta.horaInicio;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Consulta'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      enableInteractiveSelection: false,
                      controller: _inputFieldDateController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'Fecha de consulta',
                          labelText: 'Fecha de consulta',
                          suffixIcon: const Icon(Icons.perm_contact_calendar),
                          icon: const Icon(Icons.calendar_today)),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Horas de consulta'),
                      value: horaInicio,
                      onChanged: (value) {
                        setState(() {
                          horaInicio = value!;
                        });
                      },
                      items: [
                        '06:00-07:00 AM',
                        '07:00-08:00 AM',
                        '08:00-09:00 AM',
                        '09:00-10:00 AM',
                        '10:00-11:00 AM',
                        '11:00-12:00 MEDIO DIA',
                        '14:00-15:00 PM',
                        '15:00-16:00 PM',
                        '16:00-17:00 PM',
                        '17:00-18:00 PM'
                      ].map((horaInicio) {
                        return DropdownMenuItem<String>(
                          value: horaInicio,
                          child: Text(horaInicio),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Medico>(
                      value: medicoSeleccionado,
                      items: listaMedicos.map((medico) {
                        return DropdownMenuItem<Medico>(
                          value: medico,
                          child: Text(medico.nombre),
                        );
                      }).toList(),
                      onChanged: (Medico? value) {
                        setState(() {
                          medicoSeleccionado = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar médico',
                      ),
                      hint: medicoSeleccionado != null
                          ? Text(
                              'Médico seleccionado: ${medicoSeleccionado!.nombre}')
                          : const Text('Selecciona un médico'),
                    ),
                    DropdownButtonFormField<Paciente>(
                      value: pacienteSeleccionado,
                      items: listaPacientes.map((paciente) {
                        return DropdownMenuItem<Paciente>(
                          value: paciente,
                          child: Text(paciente.nombre),
                        );
                      }).toList(),
                      onChanged: (Paciente? value) {
                        setState(() {
                          pacienteSeleccionado = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar paciente',
                      ),
                      hint: pacienteSeleccionado != null
                          ? Text(
                              'Paciente seleccionado: ${pacienteSeleccionado!.nombre}')
                          : const Text('Selecciona un paciente'),
                    ),
                    TextFormField(
                      initialValue: numeroConsultorio.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Número de Consultorio',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el número de consultorio';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        numeroConsultorio = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: observaciones,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                      ),
                      onSaved: (value) {
                        observaciones = value!;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final updatedConsulta = Consulta(
                        id: consulta.id,
                        fechaConsulta: fechaConsulta,
                        horaInicio: horaInicio,
                        numeroConsultorio: numeroConsultorio,
                        medicoId: consulta.medicoId,
                        pacienteId: consulta.pacienteId,
                        observaciones: observaciones,
                      );

                      _updateConsulta(updatedConsulta);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateConsulta(Consulta consulta) async {
    await _databaseHelper.updateConsulta(consulta);
    _loadConsultas();
  }

  Future<void> _deleteConsulta(int id) async {
    await _databaseHelper.deleteConsulta(id);
    _loadConsultas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
      ),
      body: ListView.builder(
        itemCount: _consultas.length,
        itemBuilder: (context, index) {
          final consulta = _consultas[index];
          return ListTile(
            title: Text(
              'Consultorio ${consulta.numeroConsultorio}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha: ${_dateFormat.format(consulta.fechaConsulta)}',
                ),
                Text(
                  'Hora de consulta: ${consulta.horaInicio}',
                ),
                Text('Observaciones: ${consulta.observaciones}')
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(consulta);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteConsulta(consulta.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              int numeroConsultorio = 1;
              String horaInicio = '06:00-07:00 AM';
              String observaciones = '';

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Agregar Consulta'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            enableInteractiveSelection: false,
                            controller: _inputFieldDateController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                hintText: 'Fecha de consulta',
                                labelText: 'Fecha de consulta',
                                suffixIcon:
                                    const Icon(Icons.perm_contact_calendar),
                                icon: const Icon(Icons.calendar_today)),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectDate(context);
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: 'Horas de consulta'),
                            value: horaInicio,
                            onChanged: (value) {
                              setState(() {
                                horaInicio = value!;
                              });
                            },
                            items: [
                              '06:00-07:00 AM',
                              '07:00-08:00 AM',
                              '08:00-09:00 AM',
                              '09:00-10:00 AM',
                              '10:00-11:00 AM',
                              '11:00-12:00 MEDIO DIA',
                              '14:00-15:00 PM',
                              '15:00-16:00 PM',
                              '16:00-17:00 PM',
                              '17:00-18:00 PM'
                            ].map((horaInicio) {
                              return DropdownMenuItem<String>(
                                value: horaInicio,
                                child: Text(horaInicio),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<Medico>(
                            value: medicoSeleccionado,
                            items: listaMedicos.map((medico) {
                              return DropdownMenuItem<Medico>(
                                value: medico,
                                child: Text(medico.nombre),
                              );
                            }).toList(),
                            onChanged: (Medico? value) {
                              setState(() {
                                medicoSeleccionado = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar médico',
                            ),
                            hint: medicoSeleccionado != null
                                ? Text(
                                    'Médico seleccionado: ${medicoSeleccionado!.nombre}')
                                : const Text('Selecciona un médico'),
                          ),
                          DropdownButtonFormField<Paciente>(
                            value: pacienteSeleccionado,
                            items: listaPacientes.map((paciente) {
                              return DropdownMenuItem<Paciente>(
                                value: paciente,
                                child: Text(paciente.nombre),
                              );
                            }).toList(),
                            onChanged: (Paciente? value) {
                              setState(() {
                                pacienteSeleccionado = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Seleccionar paciente',
                            ),
                            hint: pacienteSeleccionado != null
                                ? Text(
                                    'Paciente seleccionado: ${pacienteSeleccionado!.nombre}')
                                : const Text('Selecciona un paciente'),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Número de Consultorio',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa el número de consultorio';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              numeroConsultorio = int.parse(value!);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Observaciones',
                            ),
                            onSaved: (value) {
                              observaciones = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Guardar'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final consulta = Consulta(
                              fechaConsulta:
                                  DateFormat.yMMMMd('en-US').parse(_fecha),
                              horaInicio: horaInicio,
                              numeroConsultorio: numeroConsultorio,
                              medicoId: 0, // Asigna el ID correcto del médico
                              pacienteId:
                                  0, // Asigna el ID correcto del paciente
                              observaciones: observaciones,
                            );

                            _saveConsulta(consulta);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    /*DateTime picked = await showDatePicker(
        context: context,
        initialDate: const DateTime.now(),
        firstDate: const DateTime(2018),
        lastDate: const DateTime(2025),
        locale: const Locale('es', 'ES'));

    //if ( picked != null ) {
    setState(() {
      _fecha = picked.toString();
      _inputFieldDateController.text = _fecha;
    });
    //}
    */
    DateTime? pickedDate = await showDatePicker(
        context: context, //context of current state
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    setState(() {
      _fecha = DateFormat.yMMMMd('en-US').format(pickedDate!);
      _inputFieldDateController.text = _fecha;
      fechaConsulta = DateFormat.yMMMMd('en-US').parse(_fecha);
    });
  }
}
