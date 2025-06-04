class AbsenceCreateRequestDto {
  final String etudiantId;
  final String vigileId;
  final DateTime date;
  final String typeAbsence;
  final String? justificationId;
  final String? courId;

  AbsenceCreateRequestDto({
    required this.etudiantId,
    required this.vigileId,
    required this.date,
    required this.typeAbsence,
    this.justificationId,
    this.courId,
  });


  Map<String, dynamic> toJson() => {
    'etudiantId': etudiantId,
    'vigileId': vigileId,
    'date': date.toIso8601String(),
    'typeAbsence': typeAbsence,
    if (justificationId != null) 'justificationId': justificationId,
    if (courId != null) 'courId': courId,
  };
}
