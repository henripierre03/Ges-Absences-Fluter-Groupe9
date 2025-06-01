import 'package:frontend_gesabsence/app/data/models/cours_model.dart';

class Salle {
  final int id;
  final String nom;
  final int capacite;
  final List<Cours> cours;
  Salle({
    required this.id,
    required this.nom,
    required this.capacite,
    this.cours = const [],
  });
  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      id: int.parse(json['id']?.toString() ?? '0'),
      nom: json['nom'],
      capacite: json['capacite'],
      cours: (json['cours'] as List<dynamic>)
          .map((c) => Cours.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'capacite': capacite,
      'cours': cours.map((c) => c.toJson()).toList(),
    };
  }
}
