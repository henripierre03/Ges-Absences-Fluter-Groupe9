import 'package:frontend_gesabsence/app/core/enums/role_enum.dart';
import 'package:frontend_gesabsence/app/data/models/user_model.dart';

class Vigile extends User {
  Vigile({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    required super.password,
    required super.role,
  });

  factory Vigile.fromJson(Map<String, dynamic> json) {
    return Vigile(
      id: json['_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {...super.toJson()};
}
