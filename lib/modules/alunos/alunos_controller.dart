import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

import '../../helpers/database_helper.dart';
import '../../models/aluno.dart';
import '../../models/turma.dart';

class AlunosController {
  final database = DatabaseHelper().database;
  var alunos = BehaviorSubject<List<Aluno>>.seeded([]);
  var turmas = BehaviorSubject<List<Turma>>.seeded([]);

  Future<void> getAllAlunos() async {
    final db = await database;
    final result = await db.query('alunos');
    final alunosList = result.map((a) => Aluno.fromMap(a)).toList();
    alunos.add(alunosList);
  }

  Future<void> addAluno(String nome, int? turmaId) async {
    final db = await database;
    await db.insert(
      'alunos',
      {'nome': nome, 'turmaId': turmaId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    getAllAlunos();
  }

  Future<void> editAluno(int id, String novoNome, int? novaTurmaId) async {
    final db = await database;
    await db.update(
      'alunos',
      {'nome': novoNome, 'turmaId': novaTurmaId},
      where: 'id = ?',
      whereArgs: [id],
    );
    getAllAlunos();
  }

  Future<void> deleteAluno(int id) async {
    final db = await database;
    await db.delete(
      'alunos',
      where: 'id = ?',
      whereArgs: [id],
    );
    getAllAlunos();
  }

  Future<void> getAllTurmas() async {
    final db = await database;
    final result = await db.query('turmas');
    final turmaList = result.map((a) => Turma.fromMap(a)).toList();
    turmas.add(turmaList);
  }

  void dispose() {
    alunos.close();
  }
}
