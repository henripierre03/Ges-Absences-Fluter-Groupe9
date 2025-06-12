class PointageRequestDto {
  final String matricule;
  final String vigileId;
  final DateTime date;

  const PointageRequestDto({
    required this.matricule,
    required this.vigileId,
    required this.date,
  });

  factory PointageRequestDto.fromJson(Map<String, dynamic> json) {
    return PointageRequestDto(
      matricule: json['matricule'] as String,
      vigileId: json['vigileId'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'matricule': matricule, 'vigileId': vigileId, 'date': date};
  }
}
