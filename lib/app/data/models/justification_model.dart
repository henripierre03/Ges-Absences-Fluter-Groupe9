class Justification {
  final int id;
  final int etudiantId;
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
      id: int.parse(json['id']?.toString() ?? '0'),
      etudiantId: int.parse(json['etudiantId']?.toString() ?? '0'),
      date: DateTime.parse(json['date']),
      justificatif: json['justificatif'],
      validation: json['validation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };
}
