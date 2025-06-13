import 'package:frontend_gesabsence/app/data/dto/response/etudiant_simple_response.dart';

class AbsenceAndEtudiantResponse {
  final String id;
  final DateTime? date;
  final String typeAbsence;
  final String? courId;
  final EtudiantSimpleResponse? etudiant;

  AbsenceAndEtudiantResponse({
    required this.id,
    this.date,
    required this.typeAbsence,
    this.courId,
    this.etudiant,
  });

  factory AbsenceAndEtudiantResponse.fromJson(Map<String, dynamic> json) {
    return AbsenceAndEtudiantResponse(
      id: json['id'] as String,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      typeAbsence: json['typeAbsence'] as String,
      courId: json['courId'] as String?,
      etudiant: json['etudiant'] != null
          ? EtudiantSimpleResponse.fromJson(json['etudiant'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'typeAbsence': typeAbsence,
      'courId': courId,
      'etudiant': etudiant?.toJson(),
    };
  }
}
