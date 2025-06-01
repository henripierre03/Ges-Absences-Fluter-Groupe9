import 'package:frontend_gesabsence/app/core/enums/module_enum.dart';
import 'package:frontend_gesabsence/app/data/models/detail_cours_model.dart';

class Cours {
  final int id;
  final Module module;
  final List<DetailCours> detailCours;
  final String salleId;

  Cours({
    required this.id,
    required this.module,
    this.detailCours = const [],
    required this.salleId,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: int.parse(json['id']?.toString() ?? '0'),
      module: Module.values.firstWhere(
        (e) => e.toString().split('.').last == json['module'],
      ),
      detailCours: (json['detailCours'] as List)
          .map((c) => DetailCours.fromJson(c as Map<String, dynamic>))
          .toList(),
      salleId: json['salleId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module': module.toString().split('.').last,
      'detailCours': detailCours.map((c) => c.toJson()).toList(),
      'salleId': salleId,
    };
  }
}
