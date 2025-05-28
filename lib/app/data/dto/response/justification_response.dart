class JustificationResponseDto {
  final String id;
  final DateTime date;
  final String justificatif;
  final bool validation;

  JustificationResponseDto({
    required this.id,
    required this.date,
    required this.justificatif,
    required this.validation,
  });

  factory JustificationResponseDto.fromJson(Map<String, dynamic> json) {
    return JustificationResponseDto(
      id: json['id'],
      date: DateTime.parse(json['date']),
      justificatif: json['justificatif'],
      validation: json['validation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'justificatif': justificatif,
    'validation': validation,
  };
}
