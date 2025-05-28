import 'package:frontend_gesabsence/app/core/enums/role_enum.dart';
import 'package:frontend_gesabsence/app/data/dto/response/absence_simple_response.dart';

class EtudiantAndAbsenceResponseDto {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final UserRole role;
  final AbsenceSimpleResponseDto absence;

  EtudiantAndAbsenceResponseDto({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.role,
    required this.absence,
  });

  factory EtudiantAndAbsenceResponseDto.fromJson(Map<String, dynamic> json) {
    return EtudiantAndAbsenceResponseDto(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      absence: AbsenceSimpleResponseDto.fromJson(json['absence']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'password': password,
    'role': role.toString().split('.').last,
    'absence': absence.toJson(),
  };
}
