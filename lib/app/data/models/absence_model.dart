import 'package:frontend_gesabsence/app/core/enums/type_absence.dart';

class Absence {
  final String id;
  final String etudiantId;
  final String vigileId;
  final DateTime date;
  final TypeAbsence absence;
  final String justificationId;
  final String courId;

  Absence({
    required this.id,
    required this.etudiantId,
    required this.vigileId,
    required this.date,
    required this.absence,
    required this.justificationId,
    required this.courId,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['_id'].toString(),
      etudiantId: json['etudiantId'].toString(),
      vigileId: json['vigileId'].toString(),
      date: DateTime.parse(json['date']),
      absence: TypeAbsence.values[json['absence']],
      justificationId: json['justificationId'].toString(),
      courId: json['coursId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'etudiantId': etudiantId,
      'vigileId': vigileId,
      'date': date.toIso8601String(),
      'absence': absence.toString().split('.').last,
      'justificationId': justificationId,
      'coursId': courId,
    };
  }
}
