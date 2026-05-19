import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  late Database db;

  DatabaseService() {
    db = sqlite3.open('darebee.db');
    _createTables();
  }

  void _createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        done INTEGER DEFAULT 0
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_id INTEGER,
        name TEXT,
        repetitions INTEGER,
        FOREIGN KEY(day_id) REFERENCES days(id)
      );
    ''');
  }
}