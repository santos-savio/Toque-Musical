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

  Future<void> addAluno(String nome) async {
    final db = await database;
    await db.insert(
      'alunos',
      {'nome': nome},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    getAllAlunos();
  }

  Future<void> editAluno(int id, String novoNome) async {
    final db = await database;
    await db.update(
      'alunos',
      {'nome': novoNome},
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

  void dispose() {
    alunos.close();
  }
}
