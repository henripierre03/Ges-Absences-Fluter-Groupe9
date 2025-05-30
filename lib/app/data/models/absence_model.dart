import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class Absence {
  final String? id;
  final String etudiantId;
  final DateTime date;
  final TypeAbsence absence;
  final String justificationId;
  final String coursId;

  Absence({
    this.id,
    required this.etudiantId,
    required this.date,
    required this.absence,
    required this.justificationId,
    required this.coursId,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['_id'],
      etudiantId: json['etudiantId'],
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values.firstWhere(
        (e) => e.toString().split('.').last == json['absence'],
      ),
      justificationId: json['justificationId'],
      coursId: json['coursId'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'etudiantId': etudiantId,
    'date': date.toIso8601String(),
    'absence': absence.toString().split('.').last,
    'justificationId': justificationId,
    'coursId': coursId,
  };
}
