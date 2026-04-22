import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('carros.db');

  final result = db.select('SELECT * FROM carros');

  for (final row in result) {
    print('ID: ${row['id']}');
    print('Cor: ${row['cor']}');
    print('Rodas: ${row['rodas']}');
    print('Potência: ${row['potencia']}');
    print('Suspensão: ${row['suspensao']}');
    print('-----------------------');
  }

  db.dispose();
}
