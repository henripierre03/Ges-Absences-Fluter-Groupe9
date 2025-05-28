import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceAndJustificationResponseDto {
  final String id;
  final String etudiantId;
  final DateTime date;
  final TypeAbsence absence;
  final String? justificationId;

  AbsenceAndJustificationResponseDto({
    required this.id,
    required this.etudiantId,
    required this.date,
    required this.absence,
    this.justificationId,
  });

  factory AbsenceAndJustificationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return AbsenceAndJustificationResponseDto(
      id: json['id'],
      etudiantId: json['etudiantId'],
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values.firstWhere(
        (e) => e.toString().split('.').last == json['absence'],
      ),
      justificationId: json['justificationId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'absence': absence.toString().split('.').last,
    'justificationId': justificationId,
  };
}
