import 'package:frontend_gesabsence/app/core/enums/niveau_enum.dart';
import 'package:frontend_gesabsence/app/core/enums/role_enum.dart';
import 'package:frontend_gesabsence/app/data/models/Absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/annee_scolaire_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';

class Etudiant extends User {
  final String matricule;
  final Niveau niveau;
  final int classeId;
  final List<AnneeScolaire> anneesScolaires = [];
  final List<Absence> absences = [];
  final String qrCode;

  Etudiant({
    required this.matricule,
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required super.password,
    required super.role,
    required this.niveau,
    required this.classeId,
    required this.qrCode,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: int.parse(json['id']?.toString() ?? '0'),
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      matricule: json['matricule'],
      niveau: NiveauExtension.fromString(json['niveau']),
      classeId: int.parse(json['classeId']?.toString() ?? '0'),
      qrCode: json['qrCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
      'matricule': matricule,
      'niveau': niveau.toString().split('.').last,
      'classeId': classeId,
      'qrCode': qrCode,
    };
  }
}
