import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistemahospital/medico.dart';
import 'package:sistemahospital/DatabaseHelper.dart';

class MedicoPage extends StatefulWidget {
  const MedicoPage({Key? key}) : super(key: key);

  @override
  _MedicoPageState createState() => _MedicoPageState();
}

class _MedicoPageState extends State<MedicoPage> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper.instance;
  final _dateFormat = DateFormat('dd/MM/yyyy');
  late List<Medico> _medicos;
  DateTime? fechaNacimiento;
  List<String> _dias = [];
  String _especialidad = 'Alergología';
  String _fecha = '';
  final TextEditingController _inputFieldDateController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicos = [];
    _loadMedicos();
  }

  Future<void> _loadMedicos() async {
    final medicos = await _databaseHelper.getAllMedicos();
    setState(() {
      _medicos = medicos;
    });
  }

  Future<void> _saveMedico(Medico medico) async {
    await _databaseHelper.insertMedico(medico);
    _loadMedicos();
  }

  Future<void> printMedicos() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<Medico> medicos = await databaseHelper.getAllMedicos();

    for (Medico medico in medicos) {
      print(medico.nombre);
    }
  }

  void _showEditDialog(Medico medico) {
    String nombre = medico.nombre;
    DateTime? fechaNacimiento = medico.fechaNacimiento;
    String genero = medico.genero;
    bool titular = medico.titular;
    _especialidad = medico.especialidad;
    _dias = medico.dias;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Medico'),
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
                          return 'Por favor, ingresa el nombre del médico';
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
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Especialidad'),
                      value: _especialidad,
                      onChanged: (value) {
                        setState(() {
                          _especialidad = value!;
                        });
                      },
                      items: ['Alergología', 'Cardiología', 'Geriatría']
                          .map((especialidad) {
                        return DropdownMenuItem<String>(
                          value: especialidad,
                          child: Text(especialidad),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('L'),
                            value: _dias.contains('Lunes'),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _dias.add('Lunes');
                                } else {
                                  _dias.remove('Lunes');
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('M'),
                            value: _dias.contains('Martes'),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _dias.add('Martes');
                                } else {
                                  _dias.remove('Martes');
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('W'),
                            value: _dias.contains('Miercoles'),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _dias.add('Miercoles');
                                } else {
                                  _dias.remove('Miercoles');
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('J'),
                            value: _dias.contains('Jueves'),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _dias.add('Jueves');
                                } else {
                                  _dias.remove('Jueves');
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('V'),
                            value: _dias.contains('Viernes'),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  _dias.add('Viernes');
                                } else {
                                  _dias.remove('Viernes');
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                    // Agregar los CheckboxListTile para los demás días de la semana
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

                      final updatedMedico = Medico(
                        id: medico.id,
                        nombre: nombre,
                        fechaNacimiento: fechaNacimiento,
                        genero: genero,
                        titular: titular,
                        especialidad: _especialidad,
                        dias: _dias,
                      );

                      _updateMedico(updatedMedico);
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

  Future<void> _updateMedico(Medico medico) async {
    await _databaseHelper.updateMedico(medico);
    _loadMedicos();
  }

  Future<void> _deleteMedico(int id) async {
    await _databaseHelper.deleteMedico(id);
    _loadMedicos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicos'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _medicos.length,
          itemBuilder: (context, index) {
            final medico = _medicos[index];
            return ListTile(
              title: Text(medico.nombre),
              subtitle: Text(
                  'Fecha de nacimiento: ${_dateFormat.format(medico.fechaNacimiento)} Especialidad:${medico.especialidad}\nDias: ${medico.dias}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(medico);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteMedico(medico.id!);
                    },
                  ),
                ],
              ),
            );
          },
        ),
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
              _especialidad = 'Alergología';
              _dias = [];

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Agregar Medico'),
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
                                return 'Por favor, ingresa el nombre del médico';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              nombre = value!;
                            },
                          ),
                          const SizedBox(height: 5),
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
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: 'Especialidad'),
                            value: _especialidad,
                            onChanged: (value) {
                              setState(() {
                                _especialidad = value!;
                              });
                            },
                            items: ['Alergología', 'Cardiología', 'Geriatría']
                                .map((especialidad) {
                              return DropdownMenuItem<String>(
                                value: especialidad,
                                child: Text(especialidad),
                              );
                            }).toList(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('L'),
                                  value: _dias.contains('Lunes'),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        _dias.add('Lunes');
                                      } else {
                                        _dias.remove('Lunes');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('M'),
                                  value: _dias.contains('Martes'),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        _dias.add('Martes');
                                      } else {
                                        _dias.remove('Martes');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('W'),
                                  value: _dias.contains('Miercoles'),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        _dias.add('Miercoles');
                                      } else {
                                        _dias.remove('Miercoles');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('J'),
                                  value: _dias.contains('Jueves'),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        _dias.add('Jueves');
                                      } else {
                                        _dias.remove('Jueves');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('V'),
                                  value: _dias.contains('Viernes'),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        _dias.add('Viernes');
                                      } else {
                                        _dias.remove('Viernes');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],

                        // Agregar los CheckboxListTile para los demás días de la semana
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

                            final medico = Medico(
                              nombre: nombre,
                              fechaNacimiento:
                                  DateFormat.yMMMMd('en-US').parse(_fecha),
                              genero: genero,
                              titular: titular,
                              especialidad: _especialidad,
                              dias: _dias,
                            );

                            _saveMedico(medico);
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
