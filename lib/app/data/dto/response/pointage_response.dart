class PointageSimpleResponseDto {
  final String message;
  final DateTime? date;
  final String? typeAbsence;

  const PointageSimpleResponseDto({
    required this.message,
    this.date,
    this.typeAbsence,
  });

  factory PointageSimpleResponseDto.fromJson(Map<String, dynamic> json) {
    return PointageSimpleResponseDto(
      message: json['message'] as String,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      typeAbsence: json['typeAbsence'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'date': date?.toIso8601String(),
      'typeAbsence': typeAbsence,
    };
  }
}
