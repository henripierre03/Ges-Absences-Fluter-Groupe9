class Absence {
  final String id;
  final String etudiantId;
  final String vigileId;
  final DateTime date;
  final String typeAbsence;
  final String? justificationId;
  final String courId;

  Absence({
    required this.id,
    required this.etudiantId,
    required this.vigileId,
    required this.date,
    required this.typeAbsence,
    this.justificationId,
    required this.courId,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] as String,
      etudiantId: json['etudiantId'] as String,
      vigileId: json['vigileId'] as String,
      date: DateTime.parse(json['date'] as String),
      typeAbsence: json['typeAbsence'] as String,
      justificationId: json['justificationId'] as String?,
      courId: json['courId'] as String,
    );
  }
}
