class Aluno {
  final int id;
  final String nome;
  final int? turmaId;

  Aluno({required this.id, required this.nome, this.turmaId});

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
      turmaId: map['turmaId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'turmaId': turmaId,
    };
  }

  @override
  bool operator ==(Object other) => other is Aluno && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
