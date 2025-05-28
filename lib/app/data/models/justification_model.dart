class Justification {
  final String id;
  final String etudiantId;
  final DateTime date;
  final String justificatif;
  final bool validation;

  Justification({
    required this.id,
    required this.etudiantId,
    required this.date,
    required this.justificatif,
    required this.validation,
  });

  factory Justification.fromJson(Map<String, dynamic> json) {
    return Justification(
      id: json['_id'],
      etudiantId: json['etudiantId'],
      date: DateTime.parse(json['date']),
      justificatif: json['justificatif'],
      validation: json['validation'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };
}
