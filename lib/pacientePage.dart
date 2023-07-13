import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistemahospital/paciente.dart';
import 'package:sistemahospital/DatabaseHelper.dart';

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});

  @override
  State<PacientePage> createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper.instance;
  final _dateFormat = DateFormat('dd/MM/yyyy');
  late List<Paciente> _pacientes;
  DateTime? fechaNacimiento;
  String _fecha = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _pacientes = [];
    _loadPacientes();
  }

  Future<void> _loadPacientes() async {
    final pacientes = await _databaseHelper.getAllPacientes();
    setState(() {
      _pacientes = pacientes;
    });
  }

  Future<void> _savePaciente(Paciente paciente) async {
    await _databaseHelper.insert(paciente);
    _loadPacientes();
  }

  void _showEditDialog(Paciente paciente) {
    String nombre = paciente.nombre;
    DateTime? fechaNacimiento = paciente.fechaNacimiento;
    String genero = paciente.genero;
    bool titular = paciente.titular;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Paciente'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: nombre,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre del paciente';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nombre = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enableInteractiveSelection: false,
                      controller: _inputFieldDateController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'Fecha de nacimiento',
                          labelText: 'Fecha de nacimiento',
                          suffixIcon: const Icon(Icons.perm_contact_calendar),
                          icon: const Icon(Icons.calendar_today)),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Género'),
                      value: genero,
                      onChanged: (value) {
                        setState(() {
                          genero = value!;
                        });
                      },
                      items: ['Masculino', 'Femenino'].map((genero) {
                        return DropdownMenuItem<String>(
                          value: genero,
                          child: Text(genero),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Titular'),
                      value: titular,
                      onChanged: (value) {
                        setState(() {
                          titular = value!;
                        });
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

                      final updatedPaciente = Paciente(
                        matricula: paciente.matricula,
                        nombre: nombre,
                        fechaNacimiento: fechaNacimiento,
                        genero: genero,
                        titular: titular,
                      );

                      _updatePaciente(updatedPaciente);
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

  Future<void> _updatePaciente(Paciente paciente) async {
    await _databaseHelper.update(paciente);
    _loadPacientes();
  }

  Future<void> _deletePaciente(int id) async {
    await _databaseHelper.delete(id);
    _loadPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: ListView.builder(
        itemCount: _pacientes.length,
        itemBuilder: (context, index) {
          final paciente = _pacientes[index];
          return ListTile(
            title: Text(paciente.nombre),
            subtitle: Text(
                'Fecha de nacimiento: ${_dateFormat.format(paciente.fechaNacimiento)} Genero: ${paciente.genero}\nTitular: ${paciente.titular}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(paciente);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deletePaciente(paciente.matricula!);
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
              String nombre = '';
              //DateTime? fechaNacimiento;
              String genero = 'Masculino';
              bool titular = false;

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Agregar Paciente'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa el nombre del paciente';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              nombre = value!;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            enableInteractiveSelection: false,
                            controller: _inputFieldDateController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                hintText: 'Fecha de nacimiento',
                                labelText: 'Fecha de nacimiento',
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
                            decoration:
                                const InputDecoration(labelText: 'Género'),
                            value: genero,
                            onChanged: (value) {
                              setState(() {
                                genero = value!;
                              });
                            },
                            items: ['Masculino', 'Femenino'].map((genero) {
                              return DropdownMenuItem<String>(
                                value: genero,
                                child: Text(genero),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            title: const Text('Titular'),
                            value: titular,
                            onChanged: (value) {
                              setState(() {
                                titular = value!;
                              });
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

                            final paciente = Paciente(
                              nombre: nombre,
                              fechaNacimiento:
                                  DateFormat.yMMMMd('en-US').parse(_fecha),
                              genero: genero,
                              titular: titular,
                            );

                            _savePaciente(paciente);
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
      fechaNacimiento = DateFormat.yMMMMd('en-US').parse(_fecha);
    });
  }
}
