import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceCreateRequestDto {
  final String etudiantId;
  final DateTime date;
  final TypeAbsence typeAbsence;
  final String justificationId;
  final String courId;

  AbsenceCreateRequestDto({
    required this.etudiantId,
    required this.date,
    required this.typeAbsence,
    required this.justificationId,
    required this.courId,
  });

  Map<String, dynamic> toJson() => {
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'typeAbsence': typeAbsence.toString().split('.').last,
    'justificationId': justificationId,
    'courId': courId,
  };
}
