import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/database_helper.dart';
import '../../models/aula.dart';
import '../../models/turma.dart';

class AulasController {
  final database = DatabaseHelper().database;
  var aulas = BehaviorSubject<List<Aula>>.seeded([]);
  var turmas = BehaviorSubject<List<Turma>>.seeded([]);

  Future<void> obterAulas() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT aulas.*, turmas.nome AS turmaNome
    FROM aulas
    JOIN turmas ON aulas.turmaId = turmas.id
    WHERE aulas.turmaId IS NOT NULL
    ORDER BY aulas.date ASC
  ''');
    final aulasList = result.map((a) => Aula.fromMap(a)).toList();
    aulas.add(aulasList);
  }

  Future<void> adicionarAula(Aula aula) async {
    final db = await database;
    await db.insert(
      'aulas',
      aula.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await obterAulas();
  }

  Future<void> editarAula(Aula aula) async {
    final db = await database;
    await db.update(
      'aulas',
      aula.toMap(),
      where: 'id = ?',
      whereArgs: [aula.id],
    );
    await obterAulas();
  }

  Future<void> getAllTurmas() async {
    final db = await database;
    final result = await db.query('turmas');
    final turmaList = result.map((a) => Turma.fromMap(a)).toList();
    turmas.add(turmaList);
  }

  Future<void> removerAula(int id) async {
    final db = await database;
    await db.delete(
      'aulas',
      where: 'id = ?',
      whereArgs: [id],
    );
    await obterAulas();
  }
}
