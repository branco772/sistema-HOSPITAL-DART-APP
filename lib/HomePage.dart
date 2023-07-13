import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistemahospital/DatabaseHelper.dart';
import 'package:sistemahospital/paciente.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper.instance;
  final _dateFormat = DateFormat('dd/MM/yyyy');
  late List<Paciente> _pacientes;
  DateTime? fechaNacimiento;
  @override
  void initState() {
    super.initState();
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

  Future<void> _deletePaciente(int id) async {
    await _databaseHelper.delete(id);
    _loadPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: _pacientes.length,
        itemBuilder: (context, index) {
          final paciente = _pacientes[index];
          return ListTile(
            title: Text(paciente.nombre),
            subtitle: Text(
                'Fecha de nacimiento: ${_dateFormat.format(paciente.fechaNacimiento)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deletePaciente(paciente.matricula!);
              },
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
              return AlertDialog(
                title: const Text('Agregar Paciente'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
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
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Fecha de Nacimiento (dd/MM/yyyy)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa la fecha de nacimiento';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          final date = _dateFormat.parseStrict(value!);
                          fechaNacimiento = date;
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
                          fechaNacimiento: fechaNacimiento != null
                              ? fechaNacimiento!
                              : DateTime.now(),
                          genero:
                              'Masculino', // Aquí puedes añadir un campo para seleccionar el género
                          titular:
                              false, // Aquí puedes añadir un campo para seleccionar si es titular o no
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
      ),
    );
  }
}
