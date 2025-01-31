class RelatorioAula {
  final String date;
  final int duration;
  final String anotacao;
  final List<AlunoTurma> alunoTurma;

  RelatorioAula({
    required this.date,
    required this.duration,
    required this.anotacao,
    required this.alunoTurma,
  });

  static List<RelatorioAula> fromMapList(List<Map<String, dynamic>> lista) {
    return lista.map((map) => RelatorioAula.fromMap(map)).toList();
  }

  factory RelatorioAula.fromMap(Map<String, dynamic> map) {
    return RelatorioAula(
      date: map['date'],
      duration: map['duration'],
      anotacao: map['anotacao'],
      alunoTurma: map['alunosTurma'] == null
          ? []
          : (map['alunosTurma'] as String).split(';').map((entry) {
              final parts = entry.split('|');
              return AlunoTurma(parts[0], parts[1]);
            }).toList(),
    );
  }
}

class AlunoTurma {
  final String turmaNome;
  final String alunoNome;

  AlunoTurma(
    this.turmaNome,
    this.alunoNome,
  );

  factory AlunoTurma.fromMap(Map<String, dynamic> map) {
    return AlunoTurma(
      map['turmaNome'],
      map['alunoNome'],
    );
  }
}
