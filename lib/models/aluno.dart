class Aluno {
  final int id;
  final String nome;

  Aluno({required this.id, required this.nome});

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'],
      nome: map['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  @override
  bool operator ==(Object other) => other is Aluno && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
