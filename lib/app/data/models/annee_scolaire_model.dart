class AnneeScolaire {
  String id;
  String annee;

  AnneeScolaire({required this.id, required this.annee});
  factory AnneeScolaire.fromJson(Map<String, dynamic> json) {
    return AnneeScolaire(
      id: json['id'] as String,
      annee: json['annee'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'annee': annee};
  }
}
