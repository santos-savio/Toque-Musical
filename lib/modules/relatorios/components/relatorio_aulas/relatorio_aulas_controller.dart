import '../../../../helpers/database_helper.dart';
import '../../../../models/relatorio_aulas.dart';

class RelatorioAulasController {
  final database = DatabaseHelper().database;

  Future<List<RelatorioAula>> obterRelatorioAulas(
      DateTime inicio, DateTime fim) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT a.id AS aulaId, a.date, a.duration, a.anotacao,
           GROUP_CONCAT(t.nome || '|' || al.nome, ';') AS alunosTurma
    FROM aulas a
    JOIN turmas t ON a.turmaId = t.id
    JOIN presenca p ON a.id = p.aulaId
    JOIN alunos al ON p.alunoId = al.id
    WHERE date(a.date) BETWEEN ? AND ?
    AND p.presente = 1
    GROUP BY a.id
    ORDER BY a.date ASC
  ''', [inicio.toIso8601String(), fim.toIso8601String()]);

    return RelatorioAula.fromMapList(result);
  }
}
