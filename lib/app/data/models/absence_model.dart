
class Absence {
  final int id;
  final int etudiantId;
  final String date;
  final String absence;
  final int? justificationId; // This field can be null
  final int coursId;

  Absence({
    required this.id,
    required this.etudiantId,
    required this.date,
    required this.absence,
    this.justificationId, // Marked as nullable
    required this.coursId,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: int.parse(json['id'].toString()),
      etudiantId: int.parse(json['etudiantId'].toString()),
      date: json['date'].toString(),
      absence: json['absence'].toString(),
      justificationId: json['justificationId'] != null
          ? int.parse(json['justificationId'].toString())
          : null, // Handle nullable justificationId
      coursId: int.parse(json['coursId'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etudiantId': etudiantId,
      'date': date,
      'absence': absence,
      'justificationId': justificationId, // Can be null
      'coursId': coursId,
    };
  }
}

  