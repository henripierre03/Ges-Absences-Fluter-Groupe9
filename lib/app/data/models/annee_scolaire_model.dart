class AnneeScolaire {
  int id;
  String annee;

  AnneeScolaire({required this.id, required this.annee});
  factory AnneeScolaire.fromJson(Map<String, dynamic> json) {
    return AnneeScolaire(
      id: int.parse(json['id']?.toString() ?? '0'),
      annee: json['annee'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'annee': annee};
  }
}
