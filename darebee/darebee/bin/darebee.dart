import 'dart:io';

import '../lib/database.dart';
import '../lib/commands.dart';

void main(List<String> args) {
  final database = DatabaseService();
  final commands = Commands(database);

  if (args.isEmpty) {
    print('Comando inválido.');
    return;
  }

  switch (args[0]) {
    case 'criar-dia':
      commands.createDay(args[1]);
      break;

    case 'ver-dia':
      commands.viewDay(int.parse(args[1]));
      break;

    case 'remover-dia':
      commands.removeDay(int.parse(args[1]));
      break;

    case 'adicionar-exercicio-dia':
      commands.addExercise(
        int.parse(args[1]),
        args[2],
        int.parse(args[3]),
      );
      break;

    case 'feito-dia':
      commands.finishDay(
        int.parse(args[1]),
      );
      break;

    default:
      print('Comando não reconhecido.');
  }
}
