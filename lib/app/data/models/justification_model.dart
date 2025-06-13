class Justification {
  final String id;
  final String etudiantId;
  final String absenceId;
  final DateTime date;
  final String message;
  final List<String> justificatif;
  final bool validation;

  Justification({
    required this.id,
    required this.etudiantId,
    required this.absenceId,
    required this.date,
    required this.message,
    required this.justificatif,
    required this.validation,
  });

  factory Justification.fromJson(Map<String, dynamic> json) {
    return Justification(
      id: json['id'],
      etudiantId: json['etudiantId'],
      absenceId: json['absenceId'],
      date: DateTime.parse(json['date']),
      message: json['message'],
      justificatif: List<String>.from(json['justificatif'] ?? []),
      validation: json['validation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'etudiantId': etudiantId,
    'absenceId': absenceId,
    'date': date.toIso8601String(),
    'message': message,
    'justificatif': justificatif,
    'validation': validation,
  };
}
