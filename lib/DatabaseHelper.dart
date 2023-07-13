import 'package:sistemahospital/consulta.dart';
import 'package:sistemahospital/medico.dart';
import 'package:sistemahospital/paciente.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "pacientes_data.db";
  static final _databaseVersion = 1;

  static final table = 'pacientes';

  static final columnMatricula = 'id';
  static final columnNombre = 'nombre';
  static final columnFechaNacimiento = 'fechaNacimiento';
  static final columnGenero = 'genero';
  static final columnTitular = 'titular';
  //TABLA MEDICO
  static final tableMedicos = 'medico';

  static final columnMedicoId = 'id';
  static final columnMedicoNombre = 'nombre';
  static final columnMedicoFechaNacimiento = 'fechaNacimiento';
  static final columnMedicoGenero = 'genero';
  static final columnMedicoTitular = 'titular';
  static final columnMedicoEspecialidad = 'especialidad';
  static final columnMedicoDias = 'dias';
//TABLA CONSULTA
  static final tableConsulta = 'consulta';

  static final columnConsultaId = 'id';
  static final columnConsultaFechaConsulta = 'fechaConsulta';
  static final columnConsultaHoraInicio = 'horaInicio';
  static final columnConsultaNumeroConsultorio = 'numeroConsultorio';
  static final columnConsultaMedicoId = 'medicoId';
  static final columnConsultaPacienteId = 'pacienteId';
  static final columnConsultaObservaciones = 'observaciones';
  // Haciendo de esta clase un Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE pacientes(
      matricula INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      fechaNacimiento TEXT,
      genero TEXT,
      titular INTEGER
    )
  ''');
    await db.execute('''
      CREATE TABLE $tableMedicos (
        $columnMedicoId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnMedicoNombre TEXT,
        $columnMedicoFechaNacimiento TEXT,
        $columnMedicoGenero TEXT,
        $columnMedicoTitular INTEGER,
        $columnMedicoEspecialidad TEXT,
        $columnMedicoDias TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE consulta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_consulta TEXT,
        hora_inicio TEXT,
        numero_consultorio INTEGER,
        medico_id INTEGER,
        paciente_id INTEGER,
        observaciones TEXT,
        FOREIGN KEY (medico_id) REFERENCES medicos (id),
        FOREIGN KEY (paciente_id) REFERENCES pacientes (id)
      )
    ''');
  }

  Future<int> insert(Paciente paciente) async {
    Database db = await instance.database;
    return await db.insert(table, paciente.toMap());
  }

  Future<List<Paciente>> getAllPacientes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (index) {
      return Paciente.fromMap(maps[index]);
    });
  }

  Future<int> update(Paciente paciente) async {
    Database db = await instance.database;
    int id = paciente.matricula!;
    return await db.update(
      table,
      paciente.toMap(),
      where: 'matricula = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: 'matricula = ?',
      whereArgs: [id],
    );
  }

//MEDICOS
  Future<int> insertMedico(Medico medico) async {
    Database db = await instance.database;
    return await db.insert(tableMedicos, medico.toMap());
  }

  Future<List<Medico>> getAllMedicos() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableMedicos);
    return List.generate(maps.length, (index) {
      return Medico.fromMap(maps[index]);
    });
  }

  Future<int> updateMedico(Medico medico) async {
    Database db = await instance.database;
    int id = medico.id!;
    return await db.update(
      tableMedicos,
      medico.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMedico(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableMedicos,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//CONSULTA
  Future<int> insertConsulta(Consulta consulta) async {
    Database db = await instance.database;
    return await db.insert(tableConsulta, consulta.toMap());
  }

  Future<List<Consulta>> getAllConsulta() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableConsulta);
    return List.generate(maps.length, (index) {
      return Consulta.fromMap(maps[index]);
    });
  }

  Future<int> updateConsulta(Consulta consulta) async {
    Database db = await instance.database;
    int id = consulta.id!;
    return await db.update(
      tableConsulta,
      consulta.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteConsulta(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableConsulta,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
