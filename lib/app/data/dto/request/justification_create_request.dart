class JustificationCreateRequestDto {
  final String etudiantId;
  final DateTime date;
  final String justificatif;
  final bool validation;

  JustificationCreateRequestDto({
    required this.etudiantId,
    required this.date,
    required this.justificatif,
    required this.validation,
  });

  Map<String, dynamic> toJson() => {
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };
}
