class Aula {
  final int? id;
  final String descricao;
  final String date; // Data da aula como String no formato ISO
  final int duration; // Duração da aula em minutos

  Aula({
    this.id,
    required this.descricao,
    required this.date,
    required this.duration,
  });

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'],
      descricao: map['descricao'],
      date: map['date'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'date': date,
      'duration': duration,
    };
  }

  @override
  bool operator ==(Object other) => other is Aula && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
