class Professor {
  final int? id;
  final String nome;

  Professor({this.id, required this.nome});

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
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
  bool operator ==(Object other) => other is Professor && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
