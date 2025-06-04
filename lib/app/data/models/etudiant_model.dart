import 'package:frontend_gesabsence/app/core/enums/filiere_enum.dart';
import 'package:frontend_gesabsence/app/core/enums/niveau_enum.dart';
import 'package:frontend_gesabsence/app/core/enums/role_enum.dart';
import 'package:frontend_gesabsence/app/data/models/Absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/annee_scolaire_model.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';

class Etudiant extends User {
  final String matricule;
  final FiliereEnum filiere;
  final Niveau niveau;
  final String classeId;
  final List<AnneeScolaire> anneesScolaires = [];
  final List<Absence> absences = [];

  Etudiant({
    required this.matricule,
    required this.filiere,
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required super.password,
    required super.role,
    required this.niveau,
    required this.classeId,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['_id'],
      filiere: FiliereExtension.fromString(json['filiere']),
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      matricule: json['matricule'],
      niveau: NiveauExtension.fromString(json['niveau']),
      classeId: json['classeId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
      'matricule': matricule,
      'niveau': niveau.toString().split('.').last,
      'classeId': classeId,
    };
  }
}
