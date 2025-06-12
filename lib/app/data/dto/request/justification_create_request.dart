class JustificationCreateRequestDto {
  final String id;
  final String etudiantId;
  final String absenceId;
  final DateTime date;
  final String justificatif;
  final bool validation;

  JustificationCreateRequestDto({
    required this.id,
    required this.etudiantId,
    required this.absenceId,
    required this.date,
    required this.justificatif,
    required this.validation,
  });

  Map<String, dynamic> toJson() => {
    '_id': id,
    'etudiantId': etudiantId,
    'absenceId': absenceId,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };

  factory JustificationCreateRequestDto.fromJson(Map<String, dynamic> json) {
    return JustificationCreateRequestDto(
      id: json['_id'],
      etudiantId: json['etudiantId'],
      absenceId: json['absenceId'],
      date: DateTime.parse(json['date']),
      justificatif: json['justificatif'],
      validation: json['validation'],
    );
  }
  static int generateNewId(List<JustificationCreateRequestDto> justifications) {
    if (justifications.isEmpty) return 1;
    final ids = justifications
        .map((j) => int.tryParse(j.id.toString()) ?? 0)
        .toList();
    return (ids.isEmpty ? 0 : ids.reduce((a, b) => a > b ? a : b)) + 1;
  }
}
