import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceSimpleResponseDto {
  final int id;
  final DateTime date;
  final TypeAbsence absence;

  AbsenceSimpleResponseDto({
    required this.id,
    required this.date,
    required this.absence,
  });

  factory AbsenceSimpleResponseDto.fromJson(Map<String, dynamic> json) {
    return AbsenceSimpleResponseDto(
      id: int.parse(json['id']?.toString() ?? '0'),
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values.firstWhere(
        (e) => e.toString().split('.').last == json['absence'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'absence': absence.toString().split('.').last,
  };
}
