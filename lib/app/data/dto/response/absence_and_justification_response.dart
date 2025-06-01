import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceAndJustificationResponseDto {
  final int id;
  final int etudiantId;
  final DateTime date;
  final TypeAbsence absence;
  final int? justificationId;

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
      id: int.parse(json['id'] ?? 0),
      etudiantId: int.parse(json['etudiantId'] ?? 0),
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values.firstWhere(
        (e) => e.toString().split('.').last == json['absence'],
      ),
      justificationId: json['justificationId'] != null
          ? int.parse(json['justificationId'].toString())
          : null,
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
