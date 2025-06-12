class EtudiantSimpleResponse {
  final String id;
  final String nom;
  final String prenom;
  final String matricule;
  final String email;
  final String role;
  final String? filiere;
  final String? niveau;
  final String? classeId;

  EtudiantSimpleResponse({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.email,
    required this.role,
    this.filiere,
    this.niveau,
    this.classeId,
  });

  factory EtudiantSimpleResponse.fromJson(Map<String, dynamic> json) {
    try {
      return EtudiantSimpleResponse(
        id: json['id']?.toString() ?? '',
        nom: json['nom']?.toString() ?? '',
        prenom: json['prenom']?.toString() ?? '',
        matricule: json['matricule']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        filiere: json['filiere']?.toString(),
        niveau: json['niveau']?.toString(),
        classeId: json['classeId']?.toString(),
      );
    } catch (e) {
      print('Erreur lors du parsing JSON: $e');
      print('JSON reçu: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'email': email,
      'role': role,
      'filiere': filiere,
      'niveau': niveau,
      'classeId': classeId,
    };
  }

  @override
  String toString() {
    return 'EtudiantSimpleResponse{id: $id, nom: $nom, prenom: $prenom, matricule: $matricule, email: $email, role: $role, filiere: $filiere, niveau: $niveau, classeId: $classeId}';
  }

  bool isValid() {
    return id.isNotEmpty &&
        nom.isNotEmpty &&
        prenom.isNotEmpty &&
        matricule.isNotEmpty;
  }
}
