import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceSimpleResponseDto {
  final int id;
  final DateTime date;
  final TypeAbsence absence;
  final String courId;

  AbsenceSimpleResponseDto({
    required this.id,
    required this.date,
    required this.absence,
    required this.courId,
  });

  factory AbsenceSimpleResponseDto.fromJson(Map<String, dynamic> json) {
    return AbsenceSimpleResponseDto(
      id: int.parse(json['id']?.toString() ?? '0'),
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values.firstWhere(
        (e) => e.toString().split('.').last == json['absence'],
      ),

      courId: json['courId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'absence': absence.toString().split('.').last,
    'courId': courId,
  };
}
