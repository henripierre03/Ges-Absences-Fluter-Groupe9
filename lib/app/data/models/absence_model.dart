class Absence {
  final String id;
  final String etudiantId;
  final String date;
  final String absence;
  final String? justificationId; // This field can be null
  final String coursId;

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
      id: json['_id']?.toString() ?? '', // Ensure it's not null
      etudiantId: json['etudiantId']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      absence: json['absence']?.toString() ?? '',
      justificationId: json['justificationId']?.toString(), // Can be null
      coursId: json['coursId']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'etudiantId': etudiantId,
      'date': date,
      'absence': absence,
      'justificationId': justificationId, // Can be null
      'coursId': coursId,
    };
  }
}
  