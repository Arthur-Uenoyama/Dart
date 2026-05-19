import 'database.dart';

class Commands {
  final DatabaseService database;

  Commands(this.database);

  void createDay(String name) {
    database.db.execute(
      'INSERT INTO days (name) VALUES (?)',
      [name],
    );

    print('Dia criado com sucesso.');
  }

  void viewDay(int id) {
    final day = database.db.select(
      'SELECT * FROM days WHERE id = ?',
      [id],
    );

    if (day.isEmpty) {
      print('Dia não encontrado.');
      return;
    }

    print('Dia: ${day.first['name']}');

    final exercises = database.db.select(
      'SELECT * FROM exercises WHERE day_id = ?',
      [id],
    );

    for (final ex in exercises) {
      print(
        '- ${ex['name']} (${ex['repetitions']} reps)',
      );
    }
  }

  void removeDay(int id) {
    database.db.execute(
      'DELETE FROM exercises WHERE day_id = ?',
      [id],
    );

    database.db.execute(
      'DELETE FROM days WHERE id = ?',
      [id],
    );

    print('Dia removido.');
  }

  void addExercise(
    int dayId,
    String name,
    int repetitions,
  ) {
    database.db.execute(
      '''
      INSERT INTO exercises (day_id, name, repetitions)
      VALUES (?, ?, ?)
      ''',
      [dayId, name, repetitions],
    );

    print('Exercício adicionado.');
  }

  void finishDay(int id) {
    database.db.execute(
      'UPDATE days SET done = 1 WHERE id = ?',
      [id],
    );

    print('Dia marcado como feito.');
  }
}