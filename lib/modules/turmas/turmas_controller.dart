import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/database_helper.dart';
import '../../models/turma.dart';

class TurmasController {
  final database = DatabaseHelper().database;
  var turmas = BehaviorSubject<List<Turma>>.seeded([]);

  Future<void> getAllTurmas() async {
    final db = await database;
    final result = await db.query('turmas');
    final turmaList = result.map((a) => Turma.fromMap(a)).toList();
    turmas.add(turmaList);
  }

  Future<void> addTurma(String nome) async {
    final db = await database;
    await db.insert(
      'turmas',
      {'nome': nome},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    getAllTurmas();
  }

  Future<void> deleteTurma(int turmaId) async {
    final db = await database;
    await db.delete(
      'alunoTurma',
      where: 'turmaId = ?',
      whereArgs: [turmaId],
    );

    await db.delete(
      'turmas',
      where: 'id = ?',
      whereArgs: [turmaId],
    );

    getAllTurmas();
  }

  void dispose() {
    turmas.close();
  }
}
