import 'package:rxdart/rxdart.dart';

import '../../helpers/database_helper.dart';
import '../../models/aluno.dart';
import '../../models/aula.dart';
import '../../models/presenca.dart';

class PresencaController {
  final database = DatabaseHelper().database;

  var aulas = BehaviorSubject<List<Aula>>.seeded([]);
  var presencas = BehaviorSubject<Map<int, List<Presenca>>>.seeded({});

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

  Future<void> carregarPresencas(int aulaId, int turmaId) async {
    final db = await database;

    // Busca os alunos da turma
    final alunosResult = await db.rawQuery('''
      SELECT alunos.id, alunos.nome
      FROM alunos
      INNER JOIN alunoTurma ON alunos.id = alunoTurma.alunoId
      WHERE alunoTurma.turmaId = ?
    ''', [turmaId]);

    final alunos = alunosResult.map((a) => Aluno.fromMap(a)).toList();

    // Busca as presenças da aula
    final presencasResult = await db.rawQuery('''
      SELECT * FROM presenca WHERE aulaId = ?
    ''', [aulaId]);

    final Map<int, Presenca> presencaMap = {
      for (var p in presencasResult.map((p) => Presenca.fromMap(p)))
        p.alunoId: p
    };

    List<Presenca> presencaList = alunos.map((aluno) {
      return presencaMap[aluno.id] ??
          Presenca(
              id: null,
              alunoId: aluno.id,
              aulaId: aulaId,
              presente: false,
              observacao: '');
    }).toList();

    final currentPresencas = presencas.value;
    currentPresencas[aulaId] = presencaList;
    presencas.add(currentPresencas);
  }

  Future<void> salvarPresencas(int aulaId) async {
    final db = await database;
    final presencaList = presencas.value[aulaId] ?? [];

    for (var presenca in presencaList) {
      if (presenca.id == null) {
        await db.insert('presenca', presenca.toMap());
      } else {
        await db.update(
          'presenca',
          presenca.toMap(),
          where: 'id = ?',
          whereArgs: [presenca.id],
        );
      }
    }
  }

  void atualizarPresenca(int aulaId, int alunoId, bool presente) {
    final currentPresencas = presencas.value;
    final presencaList = currentPresencas[aulaId] ?? [];

    for (var p in presencaList) {
      if (p.alunoId == alunoId) {
        p.presente = presente;
        break;
      }
    }

    presencas.add(currentPresencas);
  }

  void atualizarObservacao(int aulaId, int alunoId, String observacao) {
    final currentPresencas = presencas.value;
    final presencaList = currentPresencas[aulaId] ?? [];

    for (var p in presencaList) {
      if (p.alunoId == alunoId) {
        p.observacao = observacao;
        break;
      }
    }

    presencas.add(currentPresencas);
  }
}
