import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('carros.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS carros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cor TEXT,
      rodas TEXT,
      potencia INTEGER,
      suspensao TEXT
    );
  ''');

  final handler = (Request request) async {
    if (request.method == 'POST' && request.url.path == 'salvar') {
      final body = await request.readAsString();
      final data = Uri.splitQueryString(body);

      String cor = data['carColor'] ?? '';
      String rodas = data['wheelType'] ?? '';
      int potencia = int.parse(data['enginePower'] ?? '0');
      String suspensao = data['suspension'] ?? '';

      db.execute('''
        INSERT INTO carros (cor, rodas, potencia, suspensao)
        VALUES (?, ?, ?, ?)
      ''', [cor, rodas, potencia, suspensao]);

      return Response.ok('Carro salvo com sucesso!');
    }

    return Response.notFound('Rota não encontrada');
  };

  final server = await io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://localhost:8080');
}
