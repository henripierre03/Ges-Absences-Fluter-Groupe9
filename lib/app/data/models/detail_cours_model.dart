class DetailCours {
  final int id;
  final DateTime date;
  final DateTime heureDebut;
  final DateTime heureFin;
  final int coursId;
  final int classeId;

  DetailCours({
    required this.id,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.coursId,
    required this.classeId,
  });
  factory DetailCours.fromJson(Map<String, dynamic> json) {
    return DetailCours(
      id: int.parse(json['id']?.toString() ?? '0'),
      date: DateTime.parse(json['date']),
      heureDebut: DateTime.parse(json['heureDebut']),
      heureFin: DateTime.parse(json['heureFin']),
      coursId: int.parse(json['coursId']?.toString() ?? '0'),
      classeId: int.parse(json['classeId']?.toString() ?? '0'),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'heureDebut': heureDebut.toIso8601String(),
      'heureFin': heureFin.toIso8601String(),
      'coursId': coursId,
      'classeId': classeId,
    };
  }
}
