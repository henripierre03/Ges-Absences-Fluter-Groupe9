import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class AbsenceCreateRequestDto {
  final String id;
  final String etudiantId;
  final String vigileId;
  final DateTime date;
  final TypeAbsence typeAbsence;
  final String justificationId;
  final String courId;

  AbsenceCreateRequestDto({
    required this.id,
    required this.etudiantId,
    required this.vigileId,
    required this.date,
    required this.typeAbsence,
    required this.justificationId,
    required this.courId,
  });

  Map<String, dynamic> toJson() => {
    '_id': id,
    'etudiantId': etudiantId,
    'vigileId': vigileId,
    'date': date.toIso8601String(),
    'typeAbsence': typeAbsence.toString().split('.').last,
    'justificationId': justificationId,
    'courId': courId,
  };
}
