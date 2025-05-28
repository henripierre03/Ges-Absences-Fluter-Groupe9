import 'package:frontend_gesabsence/app/core/enums/role_enum.dart';

class EtudiantAllResponseDto {
  final String id;
  final String nom;
  final String prenom;
  final UserRole role;

  EtudiantAllResponseDto({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
  });

  factory EtudiantAllResponseDto.fromJson(Map<String, dynamic> json) {
    return EtudiantAllResponseDto(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
    );
  }
}
