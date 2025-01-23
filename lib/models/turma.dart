class Turma {
  final int id;
  final String nome;

  Turma({required this.id, required this.nome});

  factory Turma.fromMap(Map<String, dynamic> map) {
    return Turma(
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
  bool operator ==(Object other) => other is Turma && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
