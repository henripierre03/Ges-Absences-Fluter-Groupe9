import 'package:frontend_gesabsence/app/data/models/user_model.dart';

class Etudiant extends User {
  final String matricule;

  Etudiant({
    required this.matricule,
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required super.password,
    required super.role,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      matricule: json['matricule'],
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'matricule': matricule};
}
