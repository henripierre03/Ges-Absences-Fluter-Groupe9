class Pointage {
  final String id;
  final String matricule;
  final String date;

  Pointage({required this.id, required this.matricule, required this.date});

  factory Pointage.fromJson(Map<String, dynamic> json) {
    return Pointage(
      id: json['_id'],
      matricule: json['matricule'],
      date: json['date'],
    );
  }
  Map<String, dynamic> toJson() => {
    '_id': id,
    'matricule': matricule,
    'date': date,
  };
}
