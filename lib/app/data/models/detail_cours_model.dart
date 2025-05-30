class DetailCours {
  final String id;
  final DateTime date;
  final DateTime heureDebut;
  final DateTime heureFin;
  final String coursId;
  final String classeId;

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
      id: json['_id'],
      date: DateTime.parse(json['date']),
      heureDebut: DateTime.parse(json['heureDebut']),
      heureFin: DateTime.parse(json['heureFin']),
      coursId: json['coursId'],
      classeId: json['classeId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'heureDebut': heureDebut.toIso8601String(),
      'heureFin': heureFin.toIso8601String(),
      'coursId': coursId,
      'classeId': classeId,
    };
  }
}
