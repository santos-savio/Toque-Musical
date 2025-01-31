class AlunoTurma {
  final int alunoId;
  final int? turmaId;

  AlunoTurma({required this.alunoId, this.turmaId});

  factory AlunoTurma.fromMap(Map<String, dynamic> map) {
    return AlunoTurma(
      alunoId: map['alunoId'],
      turmaId: map['turmaId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'turmaId': turmaId,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is AlunoTurma &&
      other.alunoId == alunoId &&
      other.turmaId == turmaId;

  @override
  int get hashCode => alunoId.hashCode ^ turmaId.hashCode;
}
