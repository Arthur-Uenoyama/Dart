import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await databaseFactory.openDatabase('escola.db');

    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS disciplinas(
        codigo TEXT PRIMARY KEY,
        nome TEXT,
        periodo INTEGER,
        carga INTEGER
      )
    ''');

    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS alunos(
        prontuario TEXT PRIMARY KEY,
        nome TEXT
      )
    ''');

    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS curso(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        aluno_prontuario TEXT,
        disciplina_codigo TEXT,
        situacao TEXT
      )
    ''');

    return _database!;
  }
}
