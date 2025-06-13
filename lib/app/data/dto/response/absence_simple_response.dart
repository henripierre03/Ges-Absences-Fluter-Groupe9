class AbsenceSimpleResponseDto {
  final String id;
  final DateTime date;
  final String typeAbsence;
  final String courId;
  final String? justificationId;
  final bool hasJustification;

  AbsenceSimpleResponseDto({
    required this.id,
    required this.date,
    required this.typeAbsence,
    required this.courId,
    this.justificationId,
    this.hasJustification = false,
  });

  factory AbsenceSimpleResponseDto.fromJson(Map<String, dynamic> json) {
    return AbsenceSimpleResponseDto(
      id: json['id'] as String,
      date: DateTime.parse(json['date']),
      typeAbsence: json['typeAbsence'] as String,
      courId: json['courId'] as String,
      justificationId: json['justificationId'] as String?,
      hasJustification: json['hasJustification'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'typeAbsence': typeAbsence,
    'courId': courId,
    'justificationId': justificationId,
    'hasJustification': hasJustification,
  };
}
