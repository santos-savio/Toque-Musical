import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../../../helpers/database_helper.dart';
import '../../../models/aluno.dart';
import '../../../models/turma.dart';

class EditTurmaController {
  final database = DatabaseHelper().database;

  late Turma _turma;

  final turmaDescricaoController = TextEditingController();

  final alunoDaTurma = BehaviorSubject<List<Aluno>>.seeded([]);
  final alunosDisponiveis = BehaviorSubject<List<Aluno>>.seeded([]);

  List<Aluno> alunodaTurmaOriginal = [];
  List<Aluno> alunosDisponiveisOriginal = [];

  init(Turma turma) {
    _turma = turma;
    turmaDescricaoController.text = turma.nome;

    loadAlunos();
    loadAlunosDisponiveis();
  }

  Future<void> loadAlunos() async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT
        a.id,
        a.nome
      FROM alunos a
      INNER JOIN alunoTurma at ON at.alunoId = a.id
      WHERE at.turmaId = ?
    ''',
      [_turma.id],
    );

    alunodaTurmaOriginal = result.map((r) => Aluno.fromMap(r)).toList();
    alunoDaTurma.add(result.map((r) => Aluno.fromMap(r)).toList());
  }

  Future<void> loadAlunosDisponiveis() async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT
        a.id,
        a.nome
      FROM alunos a
      WHERE a.Id NOT IN (
        SELECT at.alunoId
        FROM alunoTurma at
        WHERE at.turmaId = ?
      )
    ''',
      [_turma.id],
    );

    alunosDisponiveisOriginal = result.map((r) => Aluno.fromMap(r)).toList();
    alunosDisponiveis.add(result.map((r) => Aluno.fromMap(r)).toList());
  }

  void adicionarAlunos(Set<Aluno> alunoIds) {
    if (alunoIds.isEmpty) return;

    alunoDaTurma.add(alunoDaTurma.value
      ..addAll(alunosDisponiveis.value.where((a) => alunoIds.contains(a))));
    alunosDisponiveis
        .add(alunosDisponiveis.value..removeWhere((a) => alunoIds.contains(a)));
  }

  void removerAluno(Aluno aluno) {
    alunoDaTurma.add(alunoDaTurma.value..remove(aluno));
    alunosDisponiveis.add(alunosDisponiveis.value..add(aluno));

    alunosDisponiveis
        .add(alunosDisponiveis.value..sort((a, b) => a.id.compareTo(b.id)));
  }

  List<int> get alunosAdicionados => alunoDaTurma.value
      .where((a) => !alunodaTurmaOriginal.contains(a))
      .map((a) => a.id)
      .toList();

  List<int> get alunosRemovidos => alunodaTurmaOriginal
      .where((a) => !alunoDaTurma.value.contains(a))
      .map((a) => a.id)
      .toList();

  Future<void> salvarTurma() async {
    await updateTurmaDescricao();
    await adicionarAlunosATurma();
    await removerAlunoDaTurma();
  }

  updateTurmaDescricao() async {
    final db = await database;

    await db.update(
      'turmas',
      {'nome': turmaDescricaoController.text},
      where: 'id = ?',
      whereArgs: [_turma.id],
    );
  }

  adicionarAlunosATurma() async {
    final db = await database;
    if (alunosAdicionados.isNotEmpty) {
      final values = alunosAdicionados
          .map((alunoId) => '($alunoId, ${_turma.id})')
          .join(',');

      await db.rawInsert(
        'INSERT INTO alunoTurma (alunoId, turmaId) VALUES $values',
      );
    }
  }

  removerAlunoDaTurma() async {
    final db = await database;

    if (alunosRemovidos.isNotEmpty) {
      final values = alunosRemovidos.map((alunoId) => '$alunoId').join(',');

      await db.rawDelete(
        'DELETE FROM alunoTurma WHERE alunoId IN ($values) AND turmaId = ?',
        [_turma.id],
      );
    }
  }

  void dispose() {
    alunoDaTurma.close();
    alunosDisponiveis.close();
  }
}
