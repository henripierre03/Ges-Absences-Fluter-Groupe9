import 'package:frontend_gesabsence/app/data/models/detail_cours_model.dart';

class Classe {
  final String id;
  final String nom;
  final List<DetailCours> detailCours;

  Classe({required this.id, required this.nom, this.detailCours = const []});
  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: json['_id'],
      nom: json['nom'],
      detailCours: (json['cours'] as List)
          .map((c) => DetailCours.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nom': nom,
      'cours': detailCours.map((c) => c.toJson()).toList(),
    };
  }
}
