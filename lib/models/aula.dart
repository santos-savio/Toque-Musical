class Aula {
  final int? id;
  final String anotacao;
  final String date;
  final int duration;
  final int? turmaId;
  String? turmaNome;

  Aula({
    this.id,
    required this.anotacao,
    required this.date,
    required this.duration,
    this.turmaId,
    this.turmaNome,
  });

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'],
      anotacao: map['anotacao'],
      date: map['date'],
      duration: map['duration'],
      turmaId: map['turmaId'],
      turmaNome: map['turmaNome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'anotacao': anotacao,
      'date': date,
      'duration': duration,
      'turmaId': turmaId,
    };
  }

  @override
  bool operator ==(Object other) => other is Aula && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
