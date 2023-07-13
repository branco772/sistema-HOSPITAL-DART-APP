import 'package:flutter/material.dart';
import 'package:sistemahospital/DatabaseHelper.dart';
import 'package:sistemahospital/consulta.dart';
import 'package:sistemahospital/medico.dart';
import 'package:sistemahospital/paciente.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int cantidadPacientes = 0;
  int cantidadMedicos = 0;
  int cantidadConsultas = 0;
  @override
  void initState() {
    super.initState();
    obtenerCantidadRegistros();
  }

  void obtenerCantidadRegistros() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;

    List<Paciente> pacientes = await databaseHelper.getAllPacientes();
    List<Medico> medicos = await databaseHelper.getAllMedicos();
    List<Consulta> consultas = await databaseHelper.getAllConsulta();
    setState(() {
      cantidadPacientes = pacientes.length;
      cantidadMedicos = medicos.length;
      cantidadConsultas = consultas.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cantidad de Pacientes: $cantidadPacientes',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 80),
            Text(
              'Cantidad de Médicos: $cantidadMedicos',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 80),
            Text(
              'Cantidad de Consultas: $cantidadConsultas',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
