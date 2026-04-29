import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import '../lib/database.dart';

final dbHelper = DatabaseHelper.instance;

void main() async {
  final router = Router();

  router.post('/disciplina', (Request req) async {
    final data = jsonDecode(await req.readAsString());
    final db = await dbHelper.database;
    await db.insert('disciplinas', data);
    return Response.ok('Disciplina cadastrada');
  });

  router.get('/disciplinas', (Request req) async {
    final db = await dbHelper.database;
    final result = await db.query('disciplinas');
    return Response.ok(jsonEncode(result));
  });

  router.post('/aluno', (Request req) async {
    final data = jsonDecode(await req.readAsString());
    final db = await dbHelper.database;
    await db.insert('alunos', data);
    return Response.ok('Aluno cadastrado');
  });

  router.get('/alunos', (Request req) async {
    final db = await dbHelper.database;
    final result = await db.query('alunos');
    return Response.ok(jsonEncode(result));
  });

  router.post('/curso', (Request req) async {
    final data = jsonDecode(await req.readAsString());
    final db = await dbHelper.database;
    await db.insert('curso', data);
    return Response.ok('Situação cadastrada');
  });

  router.get('/situacao/<prontuario>', (Request req, String prontuario) async {
    final db = await dbHelper.database;

    final aluno = await db.query('alunos',
        where: 'prontuario = ?', whereArgs: [prontuario]);

    final disciplinas = await db.rawQuery('''
      SELECT d.periodo, c.situacao
      FROM curso c
      JOIN disciplinas d ON d.codigo = c.disciplina_codigo
      WHERE c.aluno_prontuario = ?
    ''', [prontuario]);

    int maiorPeriodo = 0;
    int aprovadas = 0;

    for (var d in disciplinas) {
      if (d['periodo'] as int > maiorPeriodo) {
        maiorPeriodo = d['periodo'] as int;
      }
      if (d['situacao'] == 'Aprovado') aprovadas++;
    }

    double porcentagem =
        disciplinas.isEmpty ? 0 : (aprovadas / disciplinas.length) * 100;

    return Response.ok(jsonEncode({
      'nome': aluno.first['nome'],
      'maior_periodo': maiorPeriodo,
      'porcentagem': porcentagem
    }));
  });

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  await serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://localhost:8080');
}
