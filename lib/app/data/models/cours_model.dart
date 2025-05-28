import 'package:frontend_gesabsence/app/core/enums/module_enum.dart';

class Cours {
  final String id;
  final Module module;
  final String classeId;
  final String salleId;

  Cours({
    required this.id,
    required this.module,
    required this.classeId,
    required this.salleId,
  });

  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['_id'],
      module: Module.values.firstWhere(
        (e) => e.toString().split('.').last == json['module'],
      ),
      classeId: json['classeId'],
      salleId: json['salleId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'module': module.toString().split('.').last,
      'classeId': classeId,
      'salleId': salleId,
    };
  }
}
