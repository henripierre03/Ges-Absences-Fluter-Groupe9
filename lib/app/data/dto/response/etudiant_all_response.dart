class EtudiantAllResponseDto {
  final String id;
  final String nom;
  final String prenom;
  final String matricule;
  final String email;
  final String? role;
  final String? filiere;
  final String? niveau;

  EtudiantAllResponseDto({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.email,
    required this.role,
    required this.filiere,
    required this.niveau,
  });
  factory EtudiantAllResponseDto.fromJson(Map<String, dynamic> json) {
    return EtudiantAllResponseDto(
      id: json['id'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      matricule: json['matricule'] as String,
      email: json['email'] as String,
      role: json['role']?.toString() ?? '',
      filiere: json['filiere']?.toString(),
      niveau: json['niveau']?.toString(),
    );
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
    };
  }
}
