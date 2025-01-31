class Presenca {
  final int? id;
  final int alunoId;
  final int aulaId;
  bool presente;
  String? observacao;

  Presenca({
    this.id,
    required this.alunoId,
    required this.aulaId,
    required this.presente,
    this.observacao,
  });

  factory Presenca.fromMap(Map<String, dynamic> map) {
    return Presenca(
      id: map['id'],
      alunoId: map['alunoId'],
      aulaId: map['aulaId'],
      presente: map['presente'] == 1,
      observacao: map['observacao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alunoId': alunoId,
      'aulaId': aulaId,
      'presente': presente ? 1 : 0,
      'observacao': observacao,
    };
  }

  @override
  bool operator ==(Object other) => other is Presenca && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
